class RemoveTranslationSchema < ActiveRecord::Migration
  def self.up
    drop_table :translation_schema
  end

  def self.down
    create_table :translation_schema, :force => true do |t|
      t.integer "version", :limit => 11, :default => 0, :null => false
      t.string  "model"
    end
  end
end
