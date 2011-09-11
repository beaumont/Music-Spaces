class AddHelloworld < ActiveRecord::Migration
  def self.up    
    add_column :preferences, :show_helloworld, :boolean, :default => 1, :null => false
  end

  def self.down
    remove_column :preferences, :show_helloworld
  end
  
end
