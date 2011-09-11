class AddDownloadableToggleToContent < ActiveRecord::Migration
  def self.up
    Content.transaction do
      add_column :contents, :downloadable, :boolean, :default => false
      add_index :contents, [:type, :downloadable]
    end
  end

  def self.down
    Content.transaction do
      remove_index :contents, [:type, :downloadable]
      remove_column :contents, :downloadable
    end
  end
end
