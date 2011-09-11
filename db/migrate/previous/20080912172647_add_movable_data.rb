class AddMovableData < ActiveRecord::Migration
  def self.up
    create_table :movable_countries, :options => 'TYPE=MyISAM' do |t|
      t.string :name, :currency, :force_prefix 
      t.decimal :tax, :precision => 10, :scale => 2
      t.integer :mid, :default_brand
    end
    
    create_table :movable_operators, :options => 'TYPE=MyISAM' do |t|
      t.string :name, :mid
      t.integer :movable_country_id
    end
    
    create_table :movable_numbers, :options => 'TYPE=MyISAM' do |t|
      t.integer :number, :cost
      t.integer :cost_local, :null => true
      t.string :force_prefix
      t.integer :movable_operator_id
    end
  end

  def self.down
    drop_table :movable_countries
    drop_table :movable_operators
    drop_table :movable_numbers
  end
end
