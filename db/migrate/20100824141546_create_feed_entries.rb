class CreateFeedEntries < ActiveRecord::Migration
  def self.up
    create_table :feed_entries, :force => true do |t|
      t.integer :to_user_id, :null => false
      t.integer :content_category
      t.boolean :from_collections, :null => false, :default => false
      t.timestamps
    end
    add_index :feed_entries, [:to_user_id, :created_at]

    create_table :feed_entry_activities, :force => true do |t|
      t.integer :feed_entry_id, :null => false
      t.integer :activity_type_id
      t.integer :content_id
      t.string :content_type
      t.integer :activity_id, :null => false
      t.integer :position
    end
    add_index :feed_entry_activities, [:feed_entry_id]
    add_index :feed_entry_activities, [:activity_type_id, :content_type, :content_id], :name => 'feed_entry_activities_by_type_and_content' 

  end

  def self.down
  end
end
