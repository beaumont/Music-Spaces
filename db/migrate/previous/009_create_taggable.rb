class CreateTaggable < ActiveRecord::Migration
  def self.up
    create_table :tags, :options => 'TYPE=MyISAM', :force => true  do |t|
          t.column :name, :string
    end
  
  create_table :taggings, :options => 'TYPE=MyISAM', :force => true  do |t|
    t.column :tag_id, :integer
    t.column :taggable_id, :integer
    t.column :taggable_type, :string
    t.column :created_at, :datetime
  end
end

    def self.down
      drop_table :tags
      drop_table :taggings
    end
  end