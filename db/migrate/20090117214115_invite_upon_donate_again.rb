class InviteUponDonateAgain < ActiveRecord::Migration
  def self.up
    rename_column :currency_types, :amount_required_for_circle_invite, :amount_required_for_circle_invite_usd
    add_column :currency_types, :amount_required_for_circle_invite_rur, :decimal, :precision => 10, :scale => 2, :null => true
    add_column :currency_types, :amount_required_for_circle_invite_eur, :decimal, :precision => 10, :scale => 2, :null => true
  end

  def self.down
    remove_column :currency_types, :amount_required_for_circle_invite_eur
    remove_column :currency_types, :amount_required_for_circle_invite_rur
    rename_column :currency_types, :amount_required_for_circle_invite_usd, :amount_required_for_circle_invite
  end
end
