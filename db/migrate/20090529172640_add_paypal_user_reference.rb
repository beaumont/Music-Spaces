class AddPaypalUserReference < ActiveRecord::Migration
  def self.up
    add_column :account_settings, :paypal_user_id, :string
  end

  def self.down
    remove_column :account_settings, :paypal_user_id
  end
end
