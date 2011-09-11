class NotifyDonationRequestorsOfApprovalDelay < ActiveRecord::Migration
  def self.up
    add_column :account_settings, :notified_of_delay, :boolean, :default => false
  end

  def self.down
    remove_column :account_settings, :notified_of_delay
  end
end
