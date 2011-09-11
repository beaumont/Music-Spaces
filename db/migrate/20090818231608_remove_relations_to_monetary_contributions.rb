class RemoveRelationsToMonetaryContributions < ActiveRecord::Migration
  def self.up
    rename_column :activities, :monetary_contribution_id, :monetary_transaction_id
  end

  def self.down
    rename_column :activities, :monetary_transaction_id, :monetary_contribution_id
  end
end
