module Kroogi

# Metaprogramming to define ContentStat.favorited!(thing, by_id) and ContentStat.viewed(thing) without huge code repitition
module DynamicContentStatAccessors

  def self.included(base)
    base.extend ClassMethods
  end

  # These will become class methods... hence the name
  module ClassMethods

    # Basic - find it, create if it doesn't exist
    def find_or_create_by_content(c)
      stat = ContentStat.find(:first, :conditions => {:content_type => c.class.to_s, :content_id => c.id})
      stat ||= ContentStat.create(:content_type => c.class.to_s, :content_id => c.id)
      return stat
    end

    protected

    # Read the method name for hints
    def anonymize_stats(opts)
      user = opts[:user]
      user ||= (opts[:user_id].is_a?(User) || opts[:user_id].is_a?(Guest)) ? opts[:user_id] : User.find_by_id(opts[:user_id])
      
      opts[:user_id]    = user.id if user
      opts[:user_id]    = 1 if user && user.preference && user.preference.anonymous_stats?
      opts[:user_id]    = 0 if user.nil? || user.guest?
    end

    # Given a Stat::? class, create an entry and update the ContentStat overview for content id
    def mark_stat(klass, opts = {})
      anonymize_stats(opts)

      # Skip adding if no content, or if this stat has already been recorded during the current session
      if content = opts[:content]
        unless klass.hit_recently?(opts)
          # Create record of actual hit
          klass.hit!( opts )

          # Update the meta stat counter (ContentStat for this content_id)
          attrib = attribute_for_classname(klass)
          stat = ContentStat.find_or_create_by_content(content)
          stat.update_attributes(
          "#{attrib}" => stat.send("#{attrib}").to_i + 1,
          "#{attrib}_today" => klass.hits_today(opts)
          )
        end
      end
    end

    def remove_stat(klass, opts = {})
      anonymize_stats(opts)
      begin
        find_opts = opts.reject {|key, val| key == :content || key ==:klass} 
        hit = klass.find(:first, :conditions => find_opts)
      rescue => e
        raise "remove_stat failed to find a hit to destroy. klass = %s, opts = %s. Original exception: %s" % [klass.inspect, opts.inspect, e.inspect]
      end
      if hit 

        # Remove record of a matching hit
        hit.destroy

        # Update the meta stat counter (ContentStat for this content_id)
        attrib = attribute_for_classname(klass)
        opts[:content] ||= opts[:content_type].constantize.find(opts[:content_id])
        return nil unless opts[:content] # If content has been deleted, just quietly exit
        
        stat = ContentStat.find_or_create_by_content(opts[:content])
        stat.update_attributes(
        "#{attrib}" => stat.send("#{attrib}").to_i - 1,
        "#{attrib}_today" => klass.hits_today(opts)
        )
      end
    end


    # Stats::Favorite -> favorited, Stats::View -> viewed
    def attribute_for_classname(n)
      name = n.to_s.split('::').last.downcase
      if name.ends_with? 'e' then "#{name}d"
      else "#{name}ed"
      end
    end

    # favorited -> Stats::Favorite, viewed -> Stats::View
    def classname_for_attribute(a)
      # Prepend namespace info
      a = a.to_s
      a = "Stats::#{a.capitalize}" unless a.match '::'

      # Convert to present tense
      begin
        a[0..(a.size-3)].constantize     # e.g. viewed -- hack off 'ed'      
      rescue
        begin
          a[0..(a.size-2)].constantize   # e.g. favorited -- just take the 'd', thanks.     
        rescue
          a.constantize                  # OK, what if it was good as it was?
        end
      end
    end

    def define_stat_accessors(*args)
      args.each do |method_name|

        # getters (e.g. ContentStat.viewed and ContentStat.viewed_today)
        [method_name, "#{method_name}_today"].each do |mname|
          metaclass.send :define_method, mname.to_sym do |content|
            stat = ContentStat.find(:first, :conditions => {:content_id => content.id, :content_type => content.class.to_s}) 
            stat ? stat.send(mname).to_i : 0
          end
        end

        # setters (e.g. ContentStat.favorited!)
        metaclass.send :define_method, "#{method_name}!".to_sym do |opts|
          mark_stat(classname_for_attribute(method_name), opts)
        end

        # negative setters (e.g. ContentStat.defavorited!)
        metaclass.send :define_method, "de#{method_name}!".to_sym do |opts|
          remove_stat(classname_for_attribute(method_name), opts)
        end

      end
    end
  end
end

end