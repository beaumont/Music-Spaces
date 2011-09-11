class CreateExtraFieldsetInboxes < ActiveRecord::Migration
  def self.up
    create_table :extra_inbox_fields do |t|
      t.belongs_to :inbox
      t.string :tagline, :tagline_ru, :tagline_fr
      t.boolean :images, :tracks, :videos, :writings, :default => true
      t.boolean :archived, :default => false
      t.boolean :feature_most_recent, :default => false
      t.timestamps
    end
    add_index :extra_inbox_fields, :inbox_id
  end

  def self.down
    drop_table :extra_inbox_fields
  end
end
