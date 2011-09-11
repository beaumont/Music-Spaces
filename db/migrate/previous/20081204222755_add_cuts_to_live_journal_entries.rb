class AddCutsToLiveJournalEntries < ActiveRecord::Migration
  def self.up
    add_column :live_journal_entries, :event_cut, :text
  end

  def self.down
    remove_column :live_journal_entries, :event_cut
  end
end
