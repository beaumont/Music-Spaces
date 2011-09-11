class AddLastActivePreference < ActiveRecord::Migration
  def self.up
    add_column :preferences, :show_last_active, :boolean, :default => true
  end

  def self.down
    remove_column :preferences, :show_last_active
  end
end
