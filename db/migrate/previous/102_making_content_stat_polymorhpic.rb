class MakingContentStatPolymorhpic < ActiveRecord::Migration
  def self.up
    Stat.transaction do
      add_column :content_stats, :content_type, :string, :limit => 20
      add_index :content_stats, [:content_type, :content_id]
    
      add_column :stats, :content_type, :string, :limit => 20
      add_index :stats, [:content_type, :content_id]

      ContentStat.update_all 'content_type = "Content"'
      Stat.update_all 'content_type = "Content"'
    end
  end

  def self.down
    Stat.transaction do
      ContentStat.destroy_all 'content_type != "Content"'
      remove_index :content_stats, [:content_type, :content_id]
      remove_column :content_stats, :content_type
    
      Stat.destroy_all 'content_type != "Content"'
      remove_index :stats, [:content_type, :content_id]
      remove_column :stats, :content_type
    end
  end
end
