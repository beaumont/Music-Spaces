class AddAllowInviteRequestsToAccountSettings < ActiveRecord::Migration
  def self.up
    add_column :account_settings, :allow_invite_requests, :boolean, :default => true
  end

  def self.down
    remove_column :account_settings, :allow_invite_requests
  end
end
