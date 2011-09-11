 class AlterProfilesQuestions < ActiveRecord::Migration
   def self.up
     add_column :profile_questions, 'in_start', :boolean, :default => false
   end

   def self.down
     remove_column :profile_questions, "in_start"
   end
 end
 