class CreateDonorCoupons < ActiveRecord::Migration
  def self.up
    create_table :donor_coupons do |t|
      t.belongs_to :user, :board, :monetary_contribution
      t.string :coupon_code
      t.text :message
      t.datetime :expires_at
      t.timestamps
    end
    add_index  :donor_coupons, :user_id
    add_index  :donor_coupons, [:board_id, :monetary_contribution_id], :name => "relationship_to_contribution", :unique => true
    add_column :announcements, :generate_donor_coupons, :boolean, :default => false
    add_column :announcements, :require_minimum_to_get_coupon, :boolean, :default => true
    add_column :announcements, :coupon_expiration_date, :datetime
    add_column :announcements, :message_to_donors, :text
    add_column :announcements, :max_coupons, :integer
    
    add_index  :announcements, :generate_donor_coupons
  end

  def self.down
    remove_index  :donor_coupons, :user_id
    remove_index  :donor_coupons, :name => :relationship_to_contribution
    remove_index  :announcements, :generate_donor_coupons
    remove_column :announcements, :message_to_donors
    remove_column :announcements, :coupon_expiration_date
    remove_column :announcements, :require_minimum_to_get_coupon
    remove_column :announcements, :generate_donor_coupons
    remove_column :announcements, :max_coupons
    drop_table :donor_coupons
  end
end
