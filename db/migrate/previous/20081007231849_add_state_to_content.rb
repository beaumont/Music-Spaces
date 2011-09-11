class AddStateToContent < ActiveRecord::Migration
  def self.up
    add_column :contents, :state, :string, :default => 'active'
    add_index :contents, :state
  end

  def self.down
    remove_column :contents, :state
  end
end
