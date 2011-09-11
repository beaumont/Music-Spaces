class RemoveUsernameEncryption < ActiveRecord::Migration
  def self.up
    add_column :accounts, :login, :string
    remove_column :accounts, :crypted_username
  end

  def self.down
    raise IrreversibleMigration
  end
end
