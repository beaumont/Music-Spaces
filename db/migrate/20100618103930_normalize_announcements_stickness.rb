class NormalizeAnnouncementsStickness < ActiveRecord::Migration
  def self.up
    Announcement.update_all('priority = 0', 'priority is null')
    change_column :announcements, :priority, :boolean, :null => false, :default => false    
  end

  def self.down
  end
end
