class CleanUpContentStats < ActiveRecord::Migration
  def self.up
    ContentStat.delete_all 'content_type = "Fixnum"'
    Stat.delete_all 'content_type = "Fixnum"'    
  end

  def self.down
  end
end
