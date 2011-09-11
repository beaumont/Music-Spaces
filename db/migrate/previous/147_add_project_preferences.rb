class AddProjectPreferences < ActiveRecord::Migration
  def self.up
    # Shy founders == array of ids of founders NOT to display on kroogi page
    add_column :preferences, :shy_founders, :string
    add_column :preferences, :show_founders_tab, :boolean, :default => true
    add_column :preferences, :show_founders_module, :boolean, :default => true    
  end

  def self.down
    remove_column :preferences, :shy_founders
    remove_column :preferences, :show_founders_tab
    remove_column :preferences, :show_founders_module
  end
end
