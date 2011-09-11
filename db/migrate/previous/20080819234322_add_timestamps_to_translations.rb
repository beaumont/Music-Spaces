class AddTimestampsToTranslations < ActiveRecord::Migration
  def self.up
    add_column :globalize_translations, :created_at, :datetime
    add_column :globalize_translations, :updated_at, :datetime
    Translation.update_all ['created_at=?', Time.now], 'created_at is null'
    Translation.update_all ['updated_at=?', Time.now], 'updated_at is null'
  end

  def self.down
    remove_column :globalize_translations, :created_at
    remove_column :globalize_translations, :updated_at
  end
end
