class MakeMonetaryProcessorAccountsInheritable < ActiveRecord::Migration
  def self.up
    add_column :monetary_processor_accounts, :type, :string
  end

  def self.down
    remove_column :monetary_processor_accounts, :type
  end
end
