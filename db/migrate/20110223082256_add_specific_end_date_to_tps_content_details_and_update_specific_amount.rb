class AddSpecificEndDateToTpsContentDetailsAndUpdateSpecificAmount < ActiveRecord::Migration
  def self.up
    add_column :tps_content_details, :specific_end_date, :boolean, :default => true
    change_column :tps_content_details, :specific_amount, :boolean, :default => true
  end

  def self.down
    remove_column :tps_content_details, :specific_end_date
    change_column :tps_content_details, :specific_amount, :boolean, :default => false
  end
end
