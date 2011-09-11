class CreateLiveJournalFriends < ActiveRecord::Migration
  def self.up
    create_table :live_journal_friends do |t|
      t.integer  "account_id", :null => false
      t.datetime "last_sync",  :default => '1970-01-01 00:00:00'
    end
  end

  def self.down
    drop_table :live_journal_friends
  end
end
