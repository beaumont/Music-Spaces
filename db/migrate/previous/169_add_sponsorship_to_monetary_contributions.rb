class AddSponsorshipToMonetaryContributions < ActiveRecord::Migration
  def self.up
    add_column :monetary_contributions, :sponsorship_expiration_date, :datetime, :null => true
  end

  def self.down
    remove_column :monetary_contributions, :sponsorship_expiration_date
  end
end
