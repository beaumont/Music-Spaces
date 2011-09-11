class RemoveDuplicateActivitiesFromFriendFeed < ActiveRecord::Migration
  def self.up
    conditions = {:conditions => ['activated_at >= ?', '2010-04-17']}
    users_count = User.count(conditions) 
    User.find(:all, conditions).each_with_index do |u, idx|
      puts "processing user #{u.login}: #{idx + 1} of #{users_count}"
      activities = u.activities.only( Activity.type_group(:content_river)).not_from(u).only_friends.all(:order => 'id asc', :limit => 200)
      mask = [:activity_type_id, :from_user_id, :content_id, :content_type] 
      uniq = activities.map {|a| mask.map {|field| [field, a.send(field)]}}.uniq
      ids = []
      uniq.each do |values|
        first = activities.find {|a| values.all?{|field, value| a.send(field) == value}}
        (activities - [first]).select{|a| values.all?{|field, value| a.send(field) == value}}.each {|a| ids << a.id}
      end
      d = Activity.delete_all(['id in (?)', ids])
      puts "deleted #{d} dupe activities from friend feed"
    end
  end

  def self.down
  end
end
