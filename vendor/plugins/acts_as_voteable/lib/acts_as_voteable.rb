module ActiveRecord
  module Acts
    module Voter
      module ClassMethods
        def acts_as_voter
          include ActiveRecord::Acts::Voter::InstanceMethods
        end
      end
      
      module InstanceMethods
        def vote_down(voteable, options = {})
          vote(:down, voteable, options)
        end

        def vote_up(voteable, options = {})
          vote(:up, voteable, options)
        end

        def voted_up?(voteable, options = {})
          voted?(:up, voteable, options)
        end

        def voted_down?(voteable, options = {})
          voted?(:down, voteable, options)
        end

        private

        def voted?(direction, voteable, options = {})
           vote_class =  Vote.vote_class(direction)
           voteable.votes.find_by_user_id_and_type_and_about(id, vote_class.name, options[:about])
        end

        def vote(direction, voteable, options = {})
          if vote = voted?(direction, voteable, options)
            vote.destroy
            nil
          else
            Vote.vote_class(direction).create(
              :user => self, :voteable => voteable, :about => options[:about]
            )
          end
        end
      end
      
      private
        def self.included(base)
          base.extend(ClassMethods)
        end
    end

    module Voteable
      
      module ClassMethods
        def acts_as_voteable
          has_many :votes, :as => :voteable, :dependent => :destroy do
            def about(txt)
              self.scoped(:conditions => {:about => txt})
            end
          end

          has_many :up_votes, :as => :voteable do
            def about(txt)
              self.scoped(:conditions => {:about => txt})
            end
          end
              
          has_many :down_votes, :as => :voteable do
            def about(txt)
              self.scoped(:conditions => {:about => txt})
            end
          end
          
          extend ActiveRecord::Acts::Voteable::SingletonMethods
          include ActiveRecord::Acts::Voteable::InstanceMethods
        end
      end
      
      module InstanceMethods
        def points(options = {})
          if about = options[:about]
            count_condition = ['about = ?', about]
            up_votes.count(count_condition) - down_votes.count(count_condition)
          else
            up_votes.count - down_votes.count
          end
        end
      end
      
      module SingletonMethods
        
        def find_top(find_type, options = {})
          raise_on_illegal_options(
            options, :order, :joins, :include, :select, :group
          )
          
          joins_sql = "
            LEFT JOIN VOTES ON 
              voteable_id = #{table_name}.id AND
              voteable_type = ? 
          "
          joins_params = [name]
          
          if since = options.delete(:since)
            joins_sql << "AND votes.created_at >= ? "
            joins_params << since
          end
          
          if about = options.delete(:about)
            joins_sql << "AND votes.about = ? "
            joins_params << about
          end
          
          joins = sanitize_sql(joins_params.unshift(joins_sql))
          
          options.merge!(
            :select => "#{table_name}.id",
            :joins => joins,
            :group => "#{table_name}.id",
            :order => "sum(CASE WHEN votes.points IS NULL THEN 0 ELSE votes.points END) DESC"
          )
          
          result = find(find_type, options)
          if find_type.to_s == 'all'
            result.map!{|x| x.reload}
          end
          result
        end
        
        private
        
        def raise_on_illegal_options(options, *option_keys)
          option_keys.each do |option_key|
            if options[option_key]
              raise ArgumentError.new(
                ":#{option_key} is not a valid option to #{calling_method}"
              )
            end
          end
        end
        
        def calling_method
          stack = caller
          stack[1] =~ /`(.+)'/
          $1
        end
      end
      
      private
      
        def self.included(base)
          base.extend(ClassMethods)  
        end
    end
  end
end