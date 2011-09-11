 class AlterProfiles2 < ActiveRecord::Migration
   def self.up
      
     add_column :profiles, "date_of_birth", :datetime
     add_column :profiles, "location", :string
     add_column :profiles, "is_req_translation", :boolean, :default => false

   end

   def self.down
     remove_column :profiles, "date_of_birth"
     remove_column :profiles, "location"
     remove_column :profiles, "is_req_translation"
   end
 end
 