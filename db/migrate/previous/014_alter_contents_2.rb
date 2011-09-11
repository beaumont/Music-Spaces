class AlterContents2 < ActiveRecord::Migration
  def self.up
    add_column :contents, "is_blog_entry", :boolean, :default => false
  end

  def self.down
    remove_column :contents, "is_blog_entry"
  end
end
