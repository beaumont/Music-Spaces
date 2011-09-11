class AlterContents5 < ActiveRecord::Migration
  def self.up
    add_column :contents, :is_in_startpage, :boolean, :default => false
    add_column :contents, :is_in_myplaylist, :boolean, :default => false
  end
  def self.down
    remove_column :contents, :is_in_startpage
    remove_column :contents, :is_in_myplaylist
  end
end