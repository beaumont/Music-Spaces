namespace :lj do
  namespace :entries do
    desc "Rebuild all existing LiveJournal entries along with cuts"
    task :rebuild => :environment do
      # Could most likely be optimized but for now its not terrible...
      LiveJournalEntry.find(:all).each{|l| LiveJournalEntry.transpose_lj_tags(l, l.content_id)};nil
    end
  end
end