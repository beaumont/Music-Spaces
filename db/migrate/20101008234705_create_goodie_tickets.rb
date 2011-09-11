class CreateGoodieTickets < ActiveRecord::Migration
  def self.up
    create_table :tps_goodie_tickets, :force => true do |t|
      t.integer :goodie_id, :null => false
      t.integer :buyer_id, :null => false
      t.integer :content_details_id, :null => false
      t.string :state, :null => false
      t.string :title
      t.decimal :price, :precision => 10, :scale => 2
      t.timestamps
    end
    add_index(:tps_goodie_tickets, [:buyer_id, :state, :goodie_id], :unique => true)
  end

  def self.down
  end
end
