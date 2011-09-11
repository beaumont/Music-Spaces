class RemoveBodyCopies < ActiveRecord::Migration
  def self.up
    drop_table :body_copy
  end

  def self.down
    raise "Too lazy to fill this in -- if needed, resurrect from older migrations"
  end
end
