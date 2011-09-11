class AlterContents4 < ActiveRecord::Migration
    def self.up
        add_column :contents, "cat_id", :integer, :null => false, :default => 0
        #add_column :contents, "is_blog_entry", :boolean, :default => false
        Textentry.find(:all, :conditions => {:is_blog_entry => true}).each do |blog| 
            blog.cat_id = 1
            blog.save
        end
        remove_column :contents, "is_blog_entry"
    end

    def self.down
        remove_column :contents, "cat_id"
    end
end