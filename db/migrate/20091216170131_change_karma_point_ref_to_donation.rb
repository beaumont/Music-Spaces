class ChangeKarmaPointRefToDonation < ActiveRecord::Migration
  def self.up
    remove_column :karma_points, :monetary_donation_id
    add_column :monetary_transactions, :karma_point_id, :integer
  end

  def self.down
    remove_column :monetary_transactions, :karma_point_id
    add_column :karma_points, :monetary_donation_id, :integer
  end
end
