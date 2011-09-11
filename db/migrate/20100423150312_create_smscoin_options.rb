class CreateSmscoinOptions < ActiveRecord::Migration
  def self.up
    create_table :smscoin_cost_options, :force => true do |t|
      t.integer :version_id, :null => false, :default => false
      t.string :country_name
      t.string :country_name_ru
      t.string :country_code
      t.decimal :local_gross,  :precision => 11, :scale => 2
      t.decimal :gross_usd,  :precision => 11, :scale => 2
      t.decimal :net_usd,  :precision => 11, :scale => 2
      t.decimal :profit,  :precision => 11, :scale => 2
      t.string :currency
      t.string :provider_code
      t.string :provider_name
      t.string :provider_name_ru
      t.datetime :created_at, :null => false
    end
    add_index("smscoin_versions", ["finished"]) rescue nil
    add_index("smscoin_cost_options", ["version_id"]) rescue nil
  end
  
  def self.down
  end
end
