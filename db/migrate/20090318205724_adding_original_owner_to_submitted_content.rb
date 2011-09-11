class AddingOriginalOwnerToSubmittedContent < ActiveRecord::Migration
  def self.up
    add_column :contents, :original_owner, :string, :default => nil
    add_index :contents, :original_owner
  end

  def self.down
    remove_index :contents, :original_owner
    remove_column :contents, :original_owner
  end
end
