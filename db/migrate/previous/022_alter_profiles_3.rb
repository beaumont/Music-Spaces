 class AlterProfiles3 < ActiveRecord::Migration
   def self.up
     remove_column :profile_questions, "answer"
     add_column :profile_questions, 'answer', :text
   end

   def self.down
     
   end
 end
 