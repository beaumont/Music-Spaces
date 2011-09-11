class CreatingDefaultInboxesForExistingUsers < ActiveRecord::Migration
  def self.up

    # SPEC CHANGED, we no longer want default inboxes

    # user_ids_with_inboxes = Inbox.find(:all).collect{|x| x.user_id}.uniq
    # condition_string = user_ids_with_inboxes.empty? ? nil : ['id not in (?)', user_ids_with_inboxes]
    # 
    # count = User.active.count(:conditions => condition_string)
    # puts "Adding default inboxes for #{count} users:"
    # User.active.find(:all, :conditions => condition_string).each_with_index do |user, index|
    #   puts "\tadded #{index} of #{count}" if index % 100 == 0
    #   Inbox.create_default_for(user)
    # end
  end

  def self.down
  end
end
