class EnlargeCommentsCommentableType < ActiveRecord::Migration
  def self.up
    change_column :comments, :commentable_type, :string, :limit => 32
    change_column :users, :type, :string, :limit => 32
  end

  def self.down
  end
end
