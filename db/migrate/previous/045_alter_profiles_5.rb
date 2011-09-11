class AlterProfiles5 < ActiveRecord::Migration
  def self.up
    add_column :profiles, :invite_quota, :integer, :default => 0, :limit => 6
    User.find(2).profile.update_attributes(:invite_quota => 100)
  end

  def self.down
    remove_column :profiles, :invite_quota
  end
end
