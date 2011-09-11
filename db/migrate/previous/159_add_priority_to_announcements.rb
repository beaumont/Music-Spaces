class AddPriorityToAnnouncements < ActiveRecord::Migration
  def self.up
    add_column :announcements, :priority, :boolean, :default => false
  end

  def self.down
    remove_column :announcements, :priority
  end
end
