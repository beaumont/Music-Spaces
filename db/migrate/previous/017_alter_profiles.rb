 class AlterProfiles < ActiveRecord::Migration
   def self.up
     remove_column :profiles, :band_name
     remove_column :profiles, :avatar_path
     remove_column :profiles, :bio
     
     add_column :profiles, "account_type_id", :integer
     add_column :profiles, "avatar_id", :integer
     add_column :profiles, "userpic_id", :integer
     add_column :profiles, "bio_id", :integer

   end

   def self.down
     remove_column :profiles, "account_type_id"
     remove_column :profiles, "avatar_id"
     remove_column :profiles, "userpic_id"
     remove_column :profiles, "bio_id"
   end
 end
 