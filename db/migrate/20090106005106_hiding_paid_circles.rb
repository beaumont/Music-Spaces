class HidingPaidCircles < ActiveRecord::Migration
  def self.up
    # Right now only once circle is paid (irinaklay), miro said to go ahead and make it free
    UserKroog.find(:all, :conditions => ['price is not null']).each do |k|
      k.update_attribute(:price, nil)
    end
  end

  def self.down
  end
end
