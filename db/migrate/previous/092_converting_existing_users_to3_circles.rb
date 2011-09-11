class ConvertingExistingUsersTo3Circles < ActiveRecord::Migration
  def self.up
    # Track if using 3 or 5 kroogi circles. Default to false going forward, but any existing gets true
    add_column :preferences, :full_kroogi_circles, :boolean, :default => false
    Preference.update_all ['full_kroogi_circles = ?', true]
  end

  def self.down
    remove_column :preferences, :full_kroogi_circles
  end
end
