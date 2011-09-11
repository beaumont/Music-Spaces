class LanguageTaggingContent < ActiveRecord::Migration
  def self.up
    add_column :contents, :language_code, :string, :limit => 8
    Content.update_all 'language_code="en"'
  end

  def self.down
    remove_column :contents, :language_code
  end
end
