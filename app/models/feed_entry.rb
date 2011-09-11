#  create_table "feed_entries", :force => true do |t|
#    t.column "to_user_id",       :integer,                     :null => false
#    t.column "content_category", :integer
#    t.column "from_collections", :boolean,  :default => false, :null => false
#    t.column "created_at",       :datetime
#    t.column "updated_at",       :datetime
#  end
#
class FeedEntry < ActiveRecord::Base
  has_one :feed_entry_activity
  has_one :activity, :through => :feed_entry_activity
  named_scope :to_user,  lambda {|who| { :conditions => ['feed_entries.to_user_id = ?', who.id]} }
  named_scope :with_details, :joins => "JOIN feed_entry_activities on feed_entry_activities.feed_entry_id = feed_entries.id"
  named_scope :only,   lambda { |*categories| categories = categories.flatten; { :conditions => ['content_category in (?) OR content_category is null', categories] } }
  named_scope :newest_first, :order => 'updated_at DESC'
  named_scope :without_dirs, :conditions => ['from_collections = ?', false]

  CONTENT_CATEGORIES = {:music => 10, :pics => 20, :texts => 30, :videos => 40, :people => 50}

  def create_feed_entry_activity(to_user_id, original_activity)
    self.build_feed_entry_activity({
            :activity_type_id => original_activity.activity_type_id,
            :content_type => original_activity.content_type,
            :content_id => original_activity.content_id,
            :activity_id => original_activity.id,
            :from_user_id => original_activity.from_user_id,
            :to_user_id => to_user_id,
    }).save!
  end
  
  def self.find_or_create_container_entry(to_user_id, original_activity)
    return nil unless [Image, Track].any? {|klass| original_activity.content.is_a?(klass)} 
    container = original_activity.content.container_album if original_activity.content.is_a?(Content) 
    return nil unless container
    container_entry_activity = FeedEntryActivity.find(:first, :conditions =>
            ['content_type = ? and content_id = ? and to_user_id = ?', 'Content', container.id, to_user_id])

    if container_entry_activity
      container_entry = container_entry_activity.feed_entry
    else
      container_activity = Activity.find(:first, :conditions =>
            ['content_type = ? and content_id = ? and user_id = ?', 'Content', container.id, original_activity.user_id])
      if container_activity
        container_entry = self.create_for(to_user_id, container_activity)
      else
        log.debug "container activity not found for #{container.class.name} #{container.id}"
      end
    end
    
    container_entry
  end
  
  def self.create_for(to_user_id, original_activity, options = {})
    unless options.has_key?(:from_collection)
      options[:from_collection] = original_activity.from_user && original_activity.from_user.collection?
    end
    group_entry = find_or_create_container_entry(to_user_id, original_activity)
    if group_entry
      # no need to add FeedEntryActivity in this case: we'll query the folder contents anyway. just move the folder creation entry up
      FeedEntry.update_all(['updated_at = ?, content_category = ?',
                            original_activity.created_at, content_category_id(original_activity)],
                           ['id = ?', group_entry.id])
    else
      id = FeedEntry.connection.insert(%Q{
        insert into feed_entries(to_user_id, content_category, from_collections, created_at, updated_at)
                          values(#{to_user_id},
                                 #{content_category_id(original_activity)},
                                 #{options[:from_collection] ? 1 : 0},
                                 '#{original_activity.created_at.to_s(:db)}',
                                 '#{original_activity.created_at.to_s(:db)}')
      }, "FeedEntry Create", 'id', nil, nil)
      group_entry = FeedEntry.find(id)
      group_entry.create_feed_entry_activity(to_user_id, original_activity)
    end
    group_entry
  end

  def self.remove_directed_entries(ex_follower, followed)
    followed = followed.id if followed.is_a?(User)
    ex_follower = ex_follower.id if ex_follower.is_a?(User)
    pairs = FeedEntryActivity.connection.select_rows(%Q{
      select feed_entry_id, id
      from feed_entry_activities where from_user_id = #{followed} and to_user_id = #{ex_follower}
    })
    delete_by_id_pairs(pairs)
  end

  def self.delete_by_id_pairs(pairs)
    fea_ids = pairs.map {|fe_id, fea_id| fea_id}
    fe_ids = pairs.map {|fe_id, fea_id| fe_id}.uniq
    result = [(FeedEntry.delete_all(['id in (?)', fe_ids]) unless fe_ids.blank?) || 0]
    result << ((FeedEntryActivity.delete_all(['id in (?)', fea_ids]) unless fea_ids.blank?) || 0)
    result
  end


  def self.remove_entries_of_user(user)
    remove_content_entries(user)
    pairs = FeedEntryActivity.connection.select_rows(%Q{
      select feed_entry_id, id
      from feed_entry_activities where from_user_id = #{user.id} or to_user_id = #{user.id}
    })
    delete_by_id_pairs(pairs)
  end

  def self.remove_content_entries(thing)
    pairs = FeedEntryActivity.connection.select_rows(
            'select feed_entry_id, id from feed_entry_activities where content_type in (%s) and content_id = %s' %
                    [Activity.content_types(thing).map {|s| "'#{s}'"}.join(", "), thing.id])
    delete_by_id_pairs(pairs)
  end

  def self.remove_obsolete_feed_entries
    type_ids = [
            :published_answer, #it's here not because it's really obsolete - just have extra entries
            :published_topic,
            :published_music_contest,
            :published_blog,
            :submitted_to_inbox,
    ].map {|type| Activity::ACTIVITIES[type][:id]}
    count = FeedEntryActivity.last.id
    log_border_step = 100
    log_border = 0
    step = 10000
    done = 0
    offset = 0
    ids_cnt = 1
    while ids_cnt > 0
      ids = FeedEntryActivity.connection.select_rows("select id, feed_entry_id, activity_type_id from feed_entry_activities order by id desc limit #{offset}, #{step}")
      ids_cnt = ids.size
      offset += step
      ids = ids.select {|id, feed_entry_id, activity_type_id| type_ids.include?(activity_type_id.to_i)}
      FeedEntryActivity.delete_all(['id in (?)', ids.map {|x| x[0]}])
      done += FeedEntry.delete_all(['id in (?)', ids.map {|x| x[1]}])
      if done >= log_border
        puts "Deleted #{done} f.feed entries out of #{count} (wip)"
        log_border += log_border_step
      end
    end
    puts "Deleted #{done} f.feed entries out of #{count}"
  end

  def self.double_log(log, msg)
    puts msg
    log.debug msg
  end
  
  def self.categorize_feed_entries(log_path)
    log = Logger.new(log_path + '/categorize_feed_entries.log')
    log_border_step = (RAILS_ENV == 'production' ? 10000 : 100)
    log_border = log_border_step
    updated = 0
    FeedEntry.connection.begin_db_transaction
    count = 2744604 #ugly hardcode - too slow to count on prod, did it once now
    processed = 0
    page_size = 100
    t0 = Time.now; t00 = t0
    return unless fe = FeedEntry.last
    start_id = fe.id
    deleted = 0
    while fe = FeedEntry.last(:conditions => "content_category is null and id <= #{start_id}")
      end_id = fe.id
      start_id = fe.id - page_size
      fe_ids = FeedEntry.connection.select_rows("select id from feed_entries where content_category is null and id > #{start_id} and id <= #{end_id}").
              flatten.map(&:to_i)
      fea = nil
      FeedEntryActivity.all(:include => :content, :conditions => ["feed_entry_id in (?)", fe_ids]).each do |fea|
        fe_ids -= [fea.feed_entry_id]
        cat = content_category_id(fea)
        next unless cat
        updated += FeedEntry.update_all("content_category = #{cat}", "id = #{fea.feed_entry_id}")
      end
      deleted += FeedEntry.delete_all(['id in (?)', fe_ids]) #these don't have corresponding activities
      processed += page_size
      if updated >= log_border || deleted >= log_border
        log_border += log_border_step
        FeedEntry.connection.commit_db_transaction
        double_log(log, "committed, last fea id is #{fea ? fea.id : nil}")
        FeedEntry.connection.begin_db_transaction
      end
      if processed % log_border_step == 0
        double_log(log, "processed #{processed} feed entries out of #{count} in #{Time.now - t0}s, updated #{updated}, deleted #{deleted}.")
        t0 = Time.now
      end      
    end
    FeedEntry.connection.commit_db_transaction
    double_log(log, "updated #{updated}, deleted #{deleted} activities in #{Time.now - t00}s")
  rescue => e
    FeedEntry.connection.rollback_db_transaction
    raise e
  end

  def self.content_category_id(fea)
    content = fea.content
    return unless content

    return CONTENT_CATEGORIES[:people] if content.is_a?(Inbox)
    
    return CONTENT_CATEGORIES[:music] if [Track, MusicAlbum, MusicContest].any? {|t| content.is_a?(t)}
    return CONTENT_CATEGORIES[:music] if content.is_a?(Album) && !content.tracks.blank?

    return CONTENT_CATEGORIES[:texts] if content.class == Textentry #we don't want subclasses here
    return CONTENT_CATEGORIES[:tests] if content.is_a?(Album) && !content.contents.select {|c| c.class == Textentry}

    return CONTENT_CATEGORIES[:videos] if content.class == Video #we don't want subclasses here
    return CONTENT_CATEGORIES[:videos] if content.is_a?(Album) && !content.contents.select {|c| c.class == Video}

    return CONTENT_CATEGORIES[:pics] if content.is_a?(Image)
    return CONTENT_CATEGORIES[:pics] if content.is_a?(Album) && !content.images.blank?

    CONTENT_CATEGORIES[:people]
  end

  def self.rotate(to_keep, logger_proc)
    bucket_size = 100
    entries = [1]
    i = 0
    moved_entries, moved_entry_activities, deleted_entries, deleted_activities = [0]*4
    until_date = Time.now - to_keep
    condition = "updated_at < '#{until_date.to_s(:db)}'"
    count = FeedEntry.count(:conditions => condition)
    while !entries.empty?
      logger_proc.call("Processed #{i*bucket_size} entries out of #{count}. Moved [#{moved_entries}, #{moved_entry_activities}], deleted [#{deleted_entries}, #{deleted_entries}] entries.") if i % 10 == 0
      entries = FeedEntry.connection.select_rows("select fe.id, fea.id from feed_entries fe join feed_entry_activities fea on fe.id = fea.feed_entry_id where fe.#{condition} order by fe.updated_at limit #{bucket_size}")
      break if entries.empty?
      moved_entries += FeedEntry.connection.update("insert into feed_entries_archive select * from feed_entries where id in (#{entries.map {|fe_id, fea_id| fe_id}.join(',')})")
      moved_entry_activities += FeedEntryActivity.connection.update("insert into feed_entry_activities_archive select * from feed_entry_activities where id in (#{entries.map {|fe_id, fea_id| fea_id}.join(',')})")
      i = i + 1
      res = delete_by_id_pairs(entries)
      deleted_entries += res[0]
      deleted_activities += res[1]        
    end
    logger_proc.call("Processed #{i*bucket_size} entries out of #{count}. Moved [#{moved_entries}, #{moved_entry_activities}], deleted [#{deleted_entries}, #{deleted_entries}] entries.")
  end
end
