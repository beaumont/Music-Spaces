class RevertDefaultContentStateToActive < ActiveRecord::Migration
  def self.up
    change_column :contents, :state, :string, :default => "active"
  end

  def self.down
    change_column :contents, :state, :string, :default => "active"
  end
end