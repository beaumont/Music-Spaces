class MoreIndexTweaks < ActiveRecord::Migration
  def self.up
    remove_index :comments, [:commentable_type, :commentable_id]
    add_index :comments, [:commentable_type, :commentable_id, :deleted_at, :parent_id], :name => 'tuned_comment_index'
  end

  def self.down
    add_index :comments, [:commentable_type, :commentable_id]
    remove_index :comments, :name => 'tuned_comment_index'
  end
end
