class ModifyEndDateAndStartDate < ActiveRecord::Migration
  def self.up
    change_column :events, :end_date, :date
    change_column :events, :start_date, :date
    add_column :events, :start_time, :time
    add_column :events, :end_time, :time
  end

  def self.down
    change_column :events, :end_date, :datetime
    change_column :events, :start_date, :datetime
    remove_column :events, :end_time
    remove_column :events, :start_time
  end
end
