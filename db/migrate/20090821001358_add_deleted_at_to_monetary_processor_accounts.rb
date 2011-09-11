class AddDeletedAtToMonetaryProcessorAccounts < ActiveRecord::Migration
  def self.up
    add_column :monetary_processor_accounts, :deleted_at, :datetime
  end

  def self.down
    remove_column :monetary_processor_accounts, :deleted_at, :datetime
  end
end
