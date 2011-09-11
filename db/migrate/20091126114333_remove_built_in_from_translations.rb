class RemoveBuiltInFromTranslations < ActiveRecord::Migration
  def self.up
    remove_column :globalize_translations, :built_in
  end

  def self.down
  end
end
