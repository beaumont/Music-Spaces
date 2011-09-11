class AddModifiedByToMonetaryProcessorAccounts < ActiveRecord::Migration
  def self.up
    add_column :monetary_processor_accounts, :created_by_id, :integer
    add_column :monetary_processor_accounts, :updated_by_id, :integer
  end

  def self.down
    #not needed
  end
end
