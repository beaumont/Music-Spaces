class AddCopyrightOwnerToContent < ActiveRecord::Migration
  def self.up
    add_column :contents, :owner, :string, :nil => true
    Content.update_all 'owner = "[self]"'
  end

  def self.down
    remove_column :contents, :owner
  end
end
