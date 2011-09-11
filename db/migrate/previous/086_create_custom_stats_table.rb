class CreateCustomStatsTable < ActiveRecord::Migration
  def self.up
    create_table :content_stats do |t|
      t.integer :content_id
      t.integer :viewed,    :viewed_today
      t.integer :favorited, :favorited_today
      t.integer :commented, :commented_today
      t.integer :plays,     :plays_today
    end
    add_index :content_stats, :content_id
    
    create_table :stats do |t|
      t.integer :content_id, :user_id     # Since all we're tracking are subclasses of Content and User, we don't need polymorphism
      t.string  :type                     # STI for stats
      t.string :value, :ip                # Any tracking details
      t.timestamps
    end
    add_index :stats, [:type, :content_id]
    
    # Copy favorites to new stats table
    # Now mirrored -- stats for count, favorites table for linking, etc
    Favorite.find(:all, :conditions => {:favorable_type => %w(Image Album Content ImageThumbnail Textentry Track)}).each do |f|
      ContentStat.favorited!({:content_id => f.favorable_id, :user_id => f.user_id})
    end
    
    # Note we leave the favorite table, because apparently it's used to handle favorited pages (and maybe more)
  end

  def self.down
    Stats::Favorite.find(:all).each do |f|
      if item = Content.find_by_id(f.content_id)
        Favorite.create(:favorable_id => item.id, :favorable_type => item.class.to_s, :user_id => f.user_id )
      else
        puts "Skipping id #{f.content_id} -- doesn't seem to be any matching Content"
      end
    end
    drop_table :content_stats
    drop_table :stats    
  end
end
