class FixMisnamedAccountColumn < ActiveRecord::Migration
  def self.up
    rename_column :monetary_processor_accounts, :acount_type, :account_type
  end

  def self.down
    rename_column :monetary_processor_accounts, :account_type, :acount_type
  end
end
