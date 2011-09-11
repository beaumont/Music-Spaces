class CleanUpDeletedUsersActivities < ActiveRecord::Migration
  def self.up
    del_ids = User.find(:all, :conditions => {:state => 'deleted'}).map(&:id)
    unless del_ids.empty?
      Activity.delete_all ['user_id in (?) or from_user_id in (?)', del_ids, del_ids]
      Activity.delete_all ['content_id in (?) AND (content_type="User" OR content_type="Project")', del_ids]
    end
  end

  def self.down
  end
end
