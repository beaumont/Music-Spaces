class AddOriginsToTranslations < ActiveRecord::Migration
  def self.up
    add_column :globalize_translations, :tr_origin, :string
  end

  def self.down
    remove_column :globalize_translations, :tr_origin
  end
end
