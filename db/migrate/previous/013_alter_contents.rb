class AlterContents < ActiveRecord::Migration
  def self.up
    drop_table :text_files
    create_table :db_files, :options => 'TYPE=MyISAM', :force => true do |t|
        t.column :data, :binary
    end
    
    remove_column :contents, "text_file_id"
    add_column :contents, "db_file_id", :integer
  end

  def self.down
    drop_table :db_files
    remove_column :contents, "text_file_id"
  end
end
