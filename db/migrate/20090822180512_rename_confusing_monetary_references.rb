class RenameConfusingMonetaryReferences < ActiveRecord::Migration
  def self.up
    rename_column :monetary_transactions, :sender_id, :sender_account_setting_id
    rename_column :monetary_transactions, :receiver_id, :receiver_account_setting_id
    rename_column :monetary_transactions, :receiver_account_id, :monetary_processor_account_id
  end

  def self.down
    rename_column :monetary_transactions, :monetary_processor_account_id, :receiver_account_id
    rename_column :monetary_transactions, :receiver_account_setting_id, :receiver_id
    rename_column :monetary_transactions, :sender_account_setting_id, :sender_id
  end
end
