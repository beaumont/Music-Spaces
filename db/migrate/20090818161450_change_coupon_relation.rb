class ChangeCouponRelation < ActiveRecord::Migration
  def self.up
    rename_column :donor_coupons, :monetary_contribution_id, :monetary_donation_id
    rename_column :event_invites, :monetary_contribution_id, :monetary_donation_id
  end

  def self.down
    rename_column :event_invites, :monetary_donation_id, :monetary_contribution_id
    rename_column :donor_coupons, :monetary_donation_id, :monetary_contribution_id
  end
end
