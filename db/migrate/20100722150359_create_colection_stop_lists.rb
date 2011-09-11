class CreateColectionStopLists < ActiveRecord::Migration
  def self.up
    add_column(:collection_inclusions, :stopped, :boolean)
    CollectionInclusion.update_all('stopped = 0')
    change_column :collection_inclusions, :stopped, :boolean, :null => false, :default => false

    create_table 'collection_stop_list_items', :force => true do |t|
      t.integer :parent_id, :null => false
      t.integer :child_id, :null => false
    end

    add_index :collection_stop_list_items, [:parent_id, :child_id]

    if RAILS_ENV == 'development' #this is for those for whom it didn't work in 20100715140022_create_directory_entries.rb
      CollectionInclusion.reset_column_information
      CollectionProject.repopulate_all_inclusions(:stdout_progress => true)
    end
  end

  def self.down
  end
end
