class NoMoreSerializationForPreferences < ActiveRecord::Migration
  def self.up
    rename_column :preferences, :shy_founders, :shy_founders_ids
  end

  def self.down
    rename_column :preferences, :shy_founders_ids, :shy_founders
  end
end
