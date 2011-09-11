class SetupRelatedContent < ActiveRecord::Migration
  def self.up
    create_table(:related_contents, :id => false) do |t|
      t.integer :first_content_id, :null => false
      t.integer :second_content_id
      t.integer :download_count,  :default => 0
      t.float   :download_percentage, :default => 0.0
      t.float   :relatedness, :default => 0.0
    end
    add_index :related_contents, [:first_content_id, :relatedness]
    add_column   :activities, :from_related, :boolean, :null => false, :default => false

    create_table(:related_contents_work_table, :id => false) do |t|
      t.integer :first_content_id, :null => false
      t.integer :second_content_id
      t.integer :download_count,  :default => 0
      t.float   :download_percentage, :default => 0.0
      t.float   :relatedness, :default => 0.0
    end
    add_index :related_contents_work_table, :first_content_id
   end

  def self.down
    remove_table :related_contents
  end
end
