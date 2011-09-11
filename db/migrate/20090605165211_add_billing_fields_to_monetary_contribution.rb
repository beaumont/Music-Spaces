class AddBillingFieldsToMonetaryContribution < ActiveRecord::Migration
  def self.up
      add_column :monetary_contributions, :gross_usd, :decimal, :precision => 11, :scale => 6
      add_column :monetary_contributions, :conversion_rate, :decimal, :precision => 11, :scale =>  6
      add_column :monetary_contributions, :billable, :boolean, :default => true
      add_column :monetary_contributions, :bill_id, :integer    
      add_column :account_settings, :billable, :boolean, :default => true
      add_index :monetary_contributions, :bill_id    
      AccountSetting.update_all('billable = false') # grandfather clause
      
  end

  def self.down
    remove_index :monetary_contributions, :bill_id
    remove_column :account_settings, :billable
    remove_column :monetary_contributions, :bill_id
    remove_column :monetary_contributions, :billable
    remove_column :monetary_contributions, :conversion_rate
    remove_column :monetary_contributions, :gross_usd
  end
end
