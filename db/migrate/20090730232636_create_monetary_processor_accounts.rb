class CreateMonetaryProcessorAccounts < ActiveRecord::Migration
  def self.up
    create_table :monetary_processor_accounts do |t|
      t.integer :account_setting_id
      t.integer :monetary_processor_id
      t.string  :account_identifier
      t.string  :acount_type
      t.datetime :verified_at
      t.timestamps
    end
  end

  def self.down
    drop_table :monetary_processor_accounts
  end
end
