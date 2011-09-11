class AddAcceptanceToAccountSettings < ActiveRecord::Migration
  def self.up
    add_column :account_settings, :request_status, :string, :default => "inactive"
    updated = ActiveRecord::Base.connection.update('UPDATE `account_settings` SET `request_status` = "approved" WHERE `paypal_email` IS NOT NULL')
    puts "\nUpdate Status: #{updated}"
  end

  def self.down
    remove_column :account_settings, :request_status
  end
end
