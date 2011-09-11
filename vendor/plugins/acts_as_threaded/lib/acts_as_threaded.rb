# ActsAsThreaded
module Randomduck
  module Acts #:nodoc:
    module Commentable #:nodoc:

      def self.included(base)
        base.extend ClassMethods  
      end

      module ClassMethods
        def acts_as_threaded
          # dont use assosiation untill the polymorphism bug is resolved http://dev.rubyonrails.org/ticket/6485
          # has_many :comments, :as => :commentable, :dependent => destroy do ||
          include Randomduck::Acts::Commentable::InstanceMethods
          extend Randomduck::Acts::Commentable::SingletonMethods
        end
      end
      
      # This module contains class methods
      module SingletonMethods
        # Helper method to lookup for comments for a given object.
        # This method is equivalent to obj.all_comments.
        def find_comments_for(obj, &block)
          find_comments_for_commentable_and_commentable_id(obj.class.to_s, obj.id, &block)
        end
        
        def find_comments_for_commentable_id(commentable_id, &block)
          commentable = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s
          find_comments_for_commentable_and_commentable_id(commentable, commentable_id, &block)
        end
        
        def find_comments_for_commentable_and_commentable_id(commentable, commentable_id, &block)
          first_item = Comment.roots({:commentable_type => commentable, :commentable_id => commentable_id}).find(:all, :conditions => {:deleted_at => nil}, :order => "#{Comment.right_column_name} DESC")
          return [] if first_item.blank?
          all_children(first_item, &block)
          # todo - check whats causing all db queries
        end
        
        # Helper class method to lookup comments for
        # the mixin commentable type written by a given user.  
        # This method is NOT finding all comments for user
        def find_comments_by_user(user) 
          # TODO - does this really work with STI ?
          commentable = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s
          first_item = Comment.roots({:user_id => user.id, :commentable_type => commentable}).find(:all, :order => "#{Comment.right_column_name} DESC")
          return [] if first_item.blank?
          all_children(first_item, &block)
        end
        
        def find_comments_thread(comment_id, &block)
          first_item = Comment.roots({:id => comment_id})
          return [] if first_item.blank?
          all_children(first_item, &block)
        end
        
        
        private
        
        def all_children(parent, &block)
            options = {}
            if parent.is_a?(Array)
              tree = parent.collect{|i| i.self_and_descendants }.flatten
            else
              tree = parent.self_and_descendants
            end
            if block_given?
              tree.map{|item| [yield(item), item.id] }
            else  
              tree.map{|item| [ "#{'··' * item.level}#{item.title}", item.id]}
            end
        end
      end
      
      # This module contains instance methods
      module InstanceMethods
        
        # Helper method that defaults the submitted time.
        def add_comment(params, parent = nil)
          child_comment = Comment.new(params)
          # polymorphizm is busted fix the assignment by hand
          child_comment.commentable_type = self.class.name.to_s
          child_comment.commentable_id = self.id
          child_comment.save!
          child_comment.move_to_child_of parent unless parent.nil?
          return child_comment
        end
        
        # assosiation method todo - implement filter
        def all_comments(is_threaded = false, opts = {}, &block)
          # todo - support limit
          if is_threaded
            self.class.find_comments_for(self, &block)
          else
            opts = opts.reverse_merge(:order => "#{Comment.right_column_name} DESC, `comments`.created_at ASC")
            comments = Comment.belonging_to(self).active
            comments = comments.public unless opts[:include_private]
            if opts.has_key?(:page)
              comments = comments.paginate(:all,
                  :order => opts[:order],
                  :page => opts[:page], :per_page => opts[:per_page])
            else
              comments = comments.all(:order => opts[:order])
            end
            if block_given?
              comment.each do | comment|
                yield comment
              end
            else
              return comments
            end
          end
        end
        
        # Edited to not count deleted comments
        def comment_count(only_private = false)
          restrictions = {:deleted_at => nil}
          restrictions.merge!(:private => only_private)
          Comment.belonging_to(self).count(:all, {:conditions => restrictions})
        end
      end
    end
  end
end
