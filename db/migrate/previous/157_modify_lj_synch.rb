class ModifyLjSynch < ActiveRecord::Migration
  def self.up
    add_column :accounts, :last_manual_sync, :datetime, :null => true
  end

  def self.down
    remove_column :accounts, :last_manual_sync
  end
end
