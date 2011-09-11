class Relationships < ActiveRecord::Migration
  
  def self.up
    create_table :relationships, :options => 'TYPE=MyISAM', :force => true do |t|
      t.column :user_id, :integer, :default => 0, :null => false
      t.column :related_user_id, :integer, :default => 0, :null => false
      t.column :relationshiptype_id, :integer, :default => 0, :null => false, :limit => 4
      t.column :related_entity_id, :integer, :default => 0, :null => false
      t.column :created_at, :datetime, :null => false
      t.column :attributes, :integer, :default => 0, :null => false
    end
    add_index(:relationships, [:user_id, :relationshiptype_id, :created_at], {:name => 'index_relationships_on_userid_typeid_ts'})
    add_index(:relationships, [:related_user_id, :relationshiptype_id, :created_at], {:name => 'index_relationships_on_relateduserid_typeid_ts'})
    add_index(:relationships, :related_entity_id)
    add_index(:relationships, :created_at)

    create_table :relationshiptypes, :options => 'TYPE=MyISAM', :id => false, :force => true do |t|
      t.column :id, :integer, :default => 0, :null => false
      t.column :name, :string
      t.column :restricted, :integer, :default => 0, :null => false, :limit => 4
      t.column :position, :integer, :default => 0, :null => false, :limit => 4
    end

    create_table :contents_relationshiptypes, :id => false, :options => 'TYPE=MyISAM', :force => true do |t|
      t.column :content_id, :integer, :default => 0, :null => false
      t.column :relationshiptype_id, :integer, :default => -2, :null => false
    end
    add_index(:contents_relationshiptypes, [:content_id, :relationshiptype_id], {:name => 'index_contents_relationshiptypes_on_contentid_type'})
  end

  def self.down
      drop_table :relationships
      drop_table :relationshiptypes
      drop_table :contents_relationshiptypes
    end
end