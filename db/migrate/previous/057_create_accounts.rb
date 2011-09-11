class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :user_id, :null => false
      t.text    :crypted_username, :crypted_password, :null => false
      t.boolean :verified, :default => false
      t.datetime :last_sync, :default => '1970-1-1 00:00:00'
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
