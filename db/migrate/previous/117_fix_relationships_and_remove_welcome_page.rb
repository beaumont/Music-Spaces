class FixRelationshipsAndRemoveWelcomePage < ActiveRecord::Migration
  def self.up
    change_column :relationships, :expires_at, :datetime, :nil => true
    remove_column :preferences, :show_helloworld
  end

  def self.down
    add_column :preferences, :show_helloworld, :boolean, :default => true
  end
end
