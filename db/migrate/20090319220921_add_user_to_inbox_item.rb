class AddUserToInboxItem < ActiveRecord::Migration
  def self.up
    # Tracking who submitted, needed because for users, submitter isn't necessarily content user
    add_column :inbox_items, :user_id, :integer, :default => nil
    # Not indexed b/c won't be userd for searching
    
    # Default to user id
    InboxItem.find(:all, :include => [:content]).each do |i|
      next unless i && i.content && i.content.respond_to?(:user_id) && !i.content.user_id.blank?
      i.update_attribute(:user_id, i.content.user_id)
    end
  end

  def self.down
    remove_column :inbox_items, :user_id
  end
end
