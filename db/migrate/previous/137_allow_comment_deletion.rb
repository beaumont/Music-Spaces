class AllowCommentDeletion < ActiveRecord::Migration
  def self.up
    add_column :comments, :deleted_at, :datetime, :nil => true, :default => nil
    add_column :comments, :deleted_by, :integer, :nil => true, :default => nil
  end

  def self.down
    remove_column :comments, :deleted_at
    remove_column :comments, :deleted_by
  end
end
