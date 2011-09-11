class AddMovableBrokerEnabledFieldToAccountSetting < ActiveRecord::Migration
  def self.up
    add_column :account_settings, :movable_broker_enabled, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :account_setting, :movable_broker_enabled
  end
end
