class AddDownloadFieldToSmscoinTransaction < ActiveRecord::Migration
  def self.up
    add_column :smscoin_transactions, :download, :boolean, :default => 1, :null => false    
  end

  def self.down
  end
end
