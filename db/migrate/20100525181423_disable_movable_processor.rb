class DisableMovableProcessor < ActiveRecord::Migration
  def self.up
    processor = MonetaryProcessor.movable_broker
    processor.update_attribute(:allow_donation, false) if processor
  end

  def self.down
  end
end
