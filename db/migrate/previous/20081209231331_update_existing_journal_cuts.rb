class UpdateExistingJournalCuts < ActiveRecord::Migration
  def self.up
    # LiveJournalEntry.find(:all).each{|l| LiveJournalEntry.transpose_lj_tags(l, l.content_id)};nil
  end

  def self.down
    LiveJournalEntry.update_all("entry_cut = NULL")
  end
end
