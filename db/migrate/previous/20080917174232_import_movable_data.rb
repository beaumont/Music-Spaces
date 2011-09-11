class ImportMovableData < ActiveRecord::Migration
  def self.up
    Movable::Country.update_data_from_movable!
  end

  def self.down
  end
end
