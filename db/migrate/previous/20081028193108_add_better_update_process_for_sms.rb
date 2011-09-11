class AddBetterUpdateProcessForSms < ActiveRecord::Migration
  def self.up
    add_column :movable_countries, :version, :integer, :default => 1
    add_column :movable_operators, :version, :integer, :default => 1
    add_column :movable_numbers, :version, :integer, :default => 1
    create_table "movable_version", :options => 'TYPE=MyISAM', :force => true do |t|
      t.integer :current, :default => 1
    end
  end

  def self.down
    remove_column :movable_countries, :version
    remove_column :movable_operators, :version
    remove_column :movable_numbers, :version
    drop_table :movable_version
  end
end
