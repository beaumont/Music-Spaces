class AddSponsorshipToAccountSettings < ActiveRecord::Migration
  def self.up
    add_column :account_settings, :allow_sponsorships, :boolean, :default => false
    remove_column :account_settings, :show_donations_box_on_profile
  end

  def self.down
    add_column :account_settings, :show_donations_box_on_profile, :boolean, :default => true
    remove_column :account_settings, :allow_sponsorships
  end
end
