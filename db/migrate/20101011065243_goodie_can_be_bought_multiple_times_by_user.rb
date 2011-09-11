class GoodieCanBeBoughtMultipleTimesByUser < ActiveRecord::Migration
  def self.up
    remove_index :tps_goodie_tickets, :name => 'index_tps_goodie_tickets_on_buyer_id_and_state_and_goodie_id'
    add_index(:tps_goodie_tickets, [:buyer_id, :goodie_id, :state])    
  end

  def self.down
  end
end
