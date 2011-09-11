class CreatePlaylists < ActiveRecord::Migration
  def self.up
    create_table :playlists, :options => 'TYPE=MyISAM', :force => true do |t|
      t.column :user_id, :integer
      t.column :name, :string
      t.column :created_at, :datetime, :null => false
      t.column :created_by_id, :integer, :default => 0, :null => false
    end
  end

  def self.down
    drop_table :playlists
  end
end
