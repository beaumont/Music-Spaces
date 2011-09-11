class AddFormattedJournalEntry < ActiveRecord::Migration
  def self.up
    add_column :live_journal_entries, :event_formatted, :text
  end

  def self.down
    remove_column :live_journal_entries, :event_formatted
  end
end

