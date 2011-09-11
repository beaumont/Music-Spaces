class BetterIndexes < ActiveRecord::Migration
  def self.up
    add_index :stats, [:user_id, :content_id, :content_type, :created_at, :type], :name => 'hit_recently'
  end

  def self.down
    remove_index :stats, :name => 'hit_recently'
  end
end
