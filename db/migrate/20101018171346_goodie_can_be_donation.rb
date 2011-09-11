class GoodieCanBeDonation < ActiveRecord::Migration
  def self.up
    add_column :tps_goodies, :donation, :boolean, :default => false
    Tps::Goodie.update_all('donation = 0')
    change_column(:tps_goodies, :donation, :boolean, :null => false, :default => false)
  end

  def self.down
  end
end
