class InviteUponDonate < ActiveRecord::Migration
  def self.up
    add_column :currency_types, :amount_required_for_circle_invite, :decimal, :precision => 10, :scale => 2, :null => true
    add_column :currency_types, :circle_to_invite_to, :integer, :null => true
  end

  def self.down
    remove_column :currency_types, :circle_to_invite_to
    remove_column :currency_types, :amount_required_for_circle_invite
  end
end
