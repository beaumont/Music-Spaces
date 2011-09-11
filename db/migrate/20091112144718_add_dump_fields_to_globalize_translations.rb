class AddDumpFieldsToGlobalizeTranslations < ActiveRecord::Migration
  def self.up
    add_column :globalize_translations, :from_bundle, :string
    add_column :globalize_translations, :to_dump, :boolean, :default => false, :null => false
  end

  def self.down
  end
end
