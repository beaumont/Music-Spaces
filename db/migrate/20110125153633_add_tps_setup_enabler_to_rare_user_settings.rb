class AddTpsSetupEnablerToRareUserSettings < ActiveRecord::Migration
  def self.up
    add_column :rare_user_settings, :tps_setup_enabled, :boolean, :default => false
  end

  def self.down
    remove_column :rare_user_settings, :tps_setup_enabled
  end
end
