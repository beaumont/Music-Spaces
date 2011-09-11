class AddAttachedPurseTypes < ActiveRecord::Migration
  def self.up
    add_column :account_settings, :webmoney_wmz_attached, :boolean
    add_column :account_settings, :webmoney_wmr_attached, :boolean
    add_column :account_settings, :webmoney_wme_attached, :boolean
  end

  def self.down
    remove_column :account_settings, :webmoney_wme_attached
    remove_column :account_settings, :webmoney_wmr_attached
    remove_column :account_settings, :webmoney_wmz_attached
  end
end
