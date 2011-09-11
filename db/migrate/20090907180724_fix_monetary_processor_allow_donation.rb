class FixMonetaryProcessorAllowDonation < ActiveRecord::Migration
  def self.up
    # enable all
    execute "UPDATE monetary_processors SET allow_donation = 1"
  end

  def self.down
  end
end
