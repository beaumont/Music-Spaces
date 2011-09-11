class AddNewContentModel < ActiveRecord::Migration
  def self.up
    create_table "new_contents", :force => true do |t|
      t.integer :content_id
    end
    add_index "new_contents", ["content_id"], :name => "new_contents_content_id"
    NewContent.fill_with_content(100)
  end

  def self.down
  end
end
