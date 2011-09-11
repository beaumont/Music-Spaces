class AddShowAttributeToActivity < ActiveRecord::Migration
  def self.up
    add_column  :activities, :show, :boolean, :default => true
  end

  def self.down
    remove_column :activities, :show
  end
end
