class CreateBlockedUsers < ActiveRecord::Migration
  def self.up
    create_table :blocked_users, :force => true do |t|
      t.integer :blocked_by_id
      t.integer :blocked_user_id
      t.string  :blocked_type, :limit => 20
      t.timestamps
    end
  end

  def self.down
    drop_table :blocked_users
  end
end
