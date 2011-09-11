class TpsGoodieMayNeedAddressAndDocument < ActiveRecord::Migration
  def self.up
    add_column :tps_goodies, :needs_document, :boolean rescue nil    
    add_column :tps_goodies, :needs_address, :boolean rescue nil
    Tps::Goodie.update_all('needs_address = 0, needs_document = 0')
    Tps::Goodie.update_all('needs_address = 1', '!donation and downloadable_album_id is null')
    change_column(:tps_goodies, :needs_address, :boolean, :null => false, :default => false)
    change_column(:tps_goodies, :needs_document, :boolean, :null => false, :default => false)
  end

  def self.down
  end
end
