class AddHideSettingToProfile < ActiveRecord::Migration
  def self.up
    add_column :account_settings, :show_donations_box_on_profile, :boolean, :default => true
  end

  def self.down
    remove_column :account_settings, :show_donations_box_on_profile
  end
end
