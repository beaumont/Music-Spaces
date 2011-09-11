class AddWhereFromToInvites < ActiveRecord::Migration
  def self.up
    add_column :invites, :from_lj, :boolean, :default => false
    remove_column :account_settings, :donation_amount_wmz
    remove_column :account_settings, :donation_amount_wme
    remove_column :account_settings, :donation_amount_wmr
  end

  def self.down
    add_column :account_settings, :donation_amount_wmz, :decimal, :precision => 10, :scale => 2, :null => true
    add_column :account_settings, :donation_amount_wme, :decimal, :precision => 10, :scale => 2, :null => true
    add_column :account_settings, :donation_amount_wmr, :decimal, :precision => 10, :scale => 2, :null => true
    remove_column :invites, :from_lj
  end
end
