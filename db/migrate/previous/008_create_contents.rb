class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents, :options => 'TYPE=MyISAM', :force => true do |t|
      t.column "user_id", :integer, :null => false
      t.column "title", :string
      t.column "description", :text
      
      # inheritance type
      t.column "type", :string
        
      t.column "content_type", :string
      t.column "filename", :string  
      t.column "filepath", :string    
      t.column "size", :integer
      
      # used with thumbnails, always required
      t.column "parent_id",  :integer 
      t.column "thumbnail", :string

      
      # music specific
      
      
      # text entry specific
      t.column "text_file_id", :integer
      
      # image specific
      t.column "width", :integer  
      t.column "height", :integer
      
      
      t.column :created_at,                :datetime, :null => false
      t.column :updated_at,                :datetime, :null => false
      
    end

    # only for db-based files
    create_table :text_files, :force => true do |t|
        t.column :data, :text
    end
  end

  def self.down
    drop_table :contents
    drop_table :text_files
  end
end
