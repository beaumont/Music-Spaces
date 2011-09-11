class AddKroogiNotificationsSettings < ActiveRecord::Migration
  def self.up
    add_column :preferences, :kroogi_notify_joins_interested_circle, :boolean, :default => true
    add_column :preferences, :kroogi_notify_leaves_interested_circle, :boolean, :default => true
  end

  def self.down
    remove_column :preferences, :kroogi_notify_joins_interested_circle
    remove_column :preferences, :kroogi_notify_leaves_interested_circle
  end
end
