class RemoveDonationAccountIdentifierFromMonetaryProcessors < ActiveRecord::Migration
  def self.up
    remove_column :monetary_processors, :donation_account_identifier
  end

  def self.down
  end
end
