# == Schema Information
# Schema version: 20081006211752
#
# Table name: content_stats
#
#  id              :integer(11)     not null, primary key
#  content_id      :integer(11)
#  viewed          :integer(11)
#  viewed_today    :integer(11)
#  favorited       :integer(11)
#  favorited_today :integer(11)
#  commented       :integer(11)
#  commented_today :integer(11)
#  played          :integer(11)
#  played_today    :integer(11)
#  content_type    :string(20)
#


# Most stats for content (and Users).  Votes are still in a separate table
class ContentStat < ActiveRecord::Base

  def self.drb_tracker
    MiddleMan.worker(:stats_worker)
  end
  
  belongs_to :content, :polymorphic => true
  define_stat_accessors :favorited, :viewed, :commented, :played
  

  def self.mark_sync(content, kind, opts)
    #these are only needed to serialize content for drb_tracker, and drb_tracker deletes them to not mess with filters inside Stat's methods
    opts.delete(:id)
    opts.delete(:klass)

    self.send(kind,opts.merge(:content => content))
  end

  # Allow the various stat marking methods to be called async
  def self.mark_async(kind, opts)
    content = opts.delete(:content)
    return mark_sync(content, kind, opts) if APP_CONFIG.disable_bdrb
    opts[:klass] = content.class
    opts[:id] = content.id
#    mark_stat(Stats::View, opts)
    drb_tracker.async_mark_stat(:arg => [kind, opts])
  rescue => e
    msg = "Failed to perform stat marking asynchronously (going to retry synchronously): %s" % [e.inspect]
    #disable emailing here - there are too many of them, and email costs money
    puts msg
    mark_sync(content, kind, opts)
  end
  
  # For console stats checking
  def self.top(action = 'viewed', limit = 10, limit_to_types = [])
    condition_str = limit_to_types.empty? ? nil : ["content_type in (?)", limit_to_types]
    the_top = ContentStat.find(:all, :order => "#{action} DESC", :limit => limit, :conditions => condition_str)
    puts the_top.collect{|x| "#{x.send(action)} - #{x.content.class.name} - #{x.content.title_long}"}
  end
  
end




# OK, implemented us a stats tracker.
# 
#     * ContentStat.viewed(object_to_track) - Total views for content
#     * ContentStat.viewed_today(object_to_track) - Total views TODAY for content 
# 
#     * ContentStat.viewed!(:content => object_to_track, :user_id => user_or_id_to_credit}) - Mark a view (user, of content)
#     * ContentStat.deviewed!(:content => object_to_track, :user_id => user_or_id_to_credit}) - Un-mark a view (user, of content) 
# 
# Same pattern applies for viewed, commented, favorited, and played. To add new stats:
# 
#     # Add columns to content_stats table 
#     # Add new model file under stats/* 
#     # Add new type to define_stat_accessors declaration in content_stat.rb
# 
# Note: where possible, hits were implemented as before/after filters. Elsewhere (views, plays), the appropriate ContentStat.xxx method is called directly from a controller. 
#
# Note: stats are currently tracked on a per-user, rather than per-actor, basis.
# 
# Final Note: It's got some fun metaprogramming -- for implementation, see lib/dynamic_content_stat_accessors.rb
