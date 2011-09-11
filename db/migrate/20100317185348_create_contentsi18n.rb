class CreateContentsi18n < ActiveRecord::Migration
  def self.up
    create_table :contents_i18n, :force => true do |t|
      t.integer :content_id
      t.integer :updated_by_id
      t.column  :content_type, :string
      t.boolean :hide_from_eng_top, :null => false, :default => false
      t.timestamps
    end
    add_index :contents_i18n, :content_id
  end

  def self.down
  end
end
