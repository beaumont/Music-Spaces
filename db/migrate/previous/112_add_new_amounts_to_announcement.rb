class AddNewAmountsToAnnouncement < ActiveRecord::Migration
  def self.up
    add_column :announcements, :suggested_donation_wmz, :decimal, :precision => 10, :scale => 2, :null => true
    add_column :announcements, :suggested_donation_wme, :decimal, :precision => 10, :scale => 2, :null => true
    add_column :announcements, :suggested_donation_wmr, :decimal, :precision => 10, :scale => 2, :null => true
    
  end

  def self.down
    remove_column :announcements, :suggested_donation_wmz
    remove_column :announcements, :suggested_donation_wme
    remove_column :announcements, :suggested_donation_wmr
  end
end
