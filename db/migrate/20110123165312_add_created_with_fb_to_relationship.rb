class AddCreatedWithFbToRelationship < ActiveRecord::Migration
  def self.up
    add_column :relationships, :created_with_fb, :boolean, :default => 0
  end

  def self.down
    remove_column :relationships, :created_with_fb
  end
end
