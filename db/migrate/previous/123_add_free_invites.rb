class AddFreeInvites < ActiveRecord::Migration
  def self.up
    add_column :invites, :free, :boolean, :default => false
    add_column :monetary_contributions, :token, :string
  end

  def self.down
    remove_column :invites, :free
    remove_column :monetary_contributions, :token
  end
end
