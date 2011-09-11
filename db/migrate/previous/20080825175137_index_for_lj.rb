class IndexForLj < ActiveRecord::Migration
  def self.up
      add_index(:live_journal_entries, [:content_id, :posted_at])
  end

  def self.down
      remove_index(:live_journal_entries, [:content_id, :posted_at])
  end
end
