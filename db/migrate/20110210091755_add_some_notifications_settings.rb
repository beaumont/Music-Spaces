class AddSomeNotificationsSettings < ActiveRecord::Migration
  def self.up
    add_column :preferences, :notify_invitations_and_requests, :boolean, :default => true
    add_column :preferences, :notify_joins_interested_circle, :boolean, :default => true
    add_column :preferences, :notify_leaves_interested_circle, :boolean, :default => true
    add_column :preferences, :notify_private_messages, :boolean, :default => true
  end

  def self.down
    remove_column :preferences, :notify_invitations_and_requests
    remove_column :preferences, :notify_joins_interested_circle
    remove_column :preferences, :notify_leaves_interested_circle
    remove_column :preferences, :notify_private_messages
  end
end
