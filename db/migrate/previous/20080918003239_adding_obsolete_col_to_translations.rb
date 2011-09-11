class AddingObsoleteColToTranslations < ActiveRecord::Migration
  def self.up
    add_column :globalize_translations, :obsolete, :boolean, :default => false
  end

  def self.down
    remove_column :globalize_translations, :obsolete
  end
end
