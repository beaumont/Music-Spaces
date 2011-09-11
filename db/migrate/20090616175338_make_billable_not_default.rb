class MakeBillableNotDefault < ActiveRecord::Migration
  def self.up
    change_column :account_settings, :billable, :boolean, :default => false
  end

  def self.down
    change_column :account_settings, :billable, :boolean, :default => true
  end
end
