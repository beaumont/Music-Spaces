 class AlterContents3 < ActiveRecord::Migration
   def self.up
     add_column :contents, "foruser_id", :integer
   end

   def self.down
     remove_column :contents, "foruser_id"
   end
 end
 