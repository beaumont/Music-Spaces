class TablesForPaidKroogi < ActiveRecord::Migration
  def self.up
    change_column :user_kroogs, :price, :decimal, :precision => 10, :scale => 2, :null => true
    change_column :invites, :price, :decimal, :precision => 10, :scale => 2, :null => true
    add_column :monetary_contributions, :relationship_id, :integer
  end

  def self.down
    remove_column :monetary_contributions, :relationship_id
  end
end
