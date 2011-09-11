class RemoveInviteQuota < ActiveRecord::Migration
  def self.up
    remove_column :profiles, :invite_quota
  end

  def self.down
    add_column :profiles, :invite_quota, :integer, :default => 5
  end
end
