class Fixdbforrails < ActiveRecord::Migration
  def self.up
    rename_column :relationships, :attributes, :attributebits
  end

  def self.down
    rename_column :relationships, :attributebits, :attributes
  end
end