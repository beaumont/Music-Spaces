class AddWmAdditional < ActiveRecord::Migration
  def self.up
    add_column :account_settings, :webmoney_attached_at, :datetime
    add_column :account_settings, :webmoney_passport_level, :integer
  end

  def self.down
    remove_column :account_settings, :webmoney_passport_level
    remove_column :account_settings, :webmoney_attached_at
  end
end
