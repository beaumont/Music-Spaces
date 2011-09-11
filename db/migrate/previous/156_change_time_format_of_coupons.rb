class ChangeTimeFormatOfCoupons < ActiveRecord::Migration
  def self.up
    change_column :announcements, :coupon_expiration_date, :date
    change_column :donor_coupons, :expires_at, :date
  end

  def self.down
    # no matter
  end
end
