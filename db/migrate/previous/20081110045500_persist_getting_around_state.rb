class PersistGettingAroundState < ActiveRecord::Migration
  def self.up
    add_column :preferences, :getting_around_open, :boolean, :default => true
  end

  def self.down
    remove_column :preferences, :getting_around_open
  end
end
