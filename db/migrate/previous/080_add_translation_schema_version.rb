class AddTranslationSchemaVersion < ActiveRecord::Migration
  def self.up
    create_table :translation_schema, :force => true do |t|
      t.integer :version, :null => false, :default => 0
    end
  end

  def self.down
    drop_table :translation_schema
  end
end
