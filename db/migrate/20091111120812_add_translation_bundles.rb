require 'translation_tasks_mixin'
class AddTranslationBundles < ActiveRecord::Migration
  class <<self
    include TranslationTasksMixin
  end
  
  def self.up
    create_table :translation_bundles, :force => true do |t|
      t.integer :version, :limit => 6, :null => false #6 bytes is enough to hold numbers reflecting time like 20091106201246
      t.boolean :bulk, :default => false, :null => false
      t.datetime :created_at, :null => false
    end
    add_index :translation_bundles, :version
  end

  def self.down
  end
end
