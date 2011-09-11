class FixLjentry < ActiveRecord::Migration
  def self.up
    add_column :live_journal_entries, :content_id, :integer, :null => false, :default => 0
    add_column :live_journal_entries, :comments, :integer, :null => false, :default => 0
    add_column :live_journal_entries, :taglist, :string, :limit => 2048
  end

  def self.down
    remove_column :live_journal_entries, :content_id
    remove_column :live_journal_entries, :comments
    remove_column :live_journal_entries, :taglist
  end
end
