class CreateLiveJournalEntries < ActiveRecord::Migration
  def self.up
    create_table :live_journal_entries do |t|
      t.integer :account_id, :null => false
      t.integer :anum, :journal_item_id
      t.boolean :backdated, :preformatted
      t.text :event
      t.string :subject, :music, :location
      t.string :security, :screening
      t.datetime :posted_at
      t.timestamps
    end
    add_index :live_journal_entries, [:account_id, :journal_item_id], :name => "lj_entries_account_and_item"
  end

  def self.down
    drop_table :live_journal_entries
    remove_index :live_journal_entries, :name => :lj_entries_account_and_item
  end
end
