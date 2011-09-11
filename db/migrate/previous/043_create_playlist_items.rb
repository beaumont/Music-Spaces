class CreatePlaylistItems < ActiveRecord::Migration
  def self.up
    create_table :playlist_items, :options => 'TYPE=MyISAM', :force => true do |t|
      t.column :playlist_id, :integer
      t.column :position, :integer
      t.column :track_id, :string
      t.column :created_at, :datetime, :null => false
      t.column :created_by_id, :integer, :default => 0, :null => false
    end
  end

  def self.down
    drop_table :playlist_items
  end
end
