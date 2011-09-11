class AddAccessKeyToDonorCoupons < ActiveRecord::Migration
  def self.up
    add_column :donor_coupons, :access_key, :string
    DonorCoupon.find(:all).each { |dc| dc.send(:generate_access_key) and dc.save  }
  end

  def self.down
    remove_column :donor_coupons, :access_key
  end
end
