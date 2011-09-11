class CreateDirectoryEntries < ActiveRecord::Migration
  non_transactional

  def self.up
    create_table 'collection_inclusions', :force => true do |t|
      t.integer :parent_id, :null => false
      t.integer :child_pac_id, :null => false
      t.integer :child_user_id, :null => false
      t.integer :direct_parent_id, :null => false
      t.boolean :child_is_collection, :null => false
    end
    
    unless RAILS_ENV == 'production' #we'll do it separately at Prod
      CollectionProject.repopulate_all_inclusions(:stdout_progress => true) rescue nil
    else
      puts "be sure to run CollectionProject.repopulate_all_inclusions from console!"
    end
  end

  def self.down
  end
end
