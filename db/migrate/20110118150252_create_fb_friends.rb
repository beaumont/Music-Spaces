class CreateFbFriends < ActiveRecord::Migration
  def self.up
    create_table :fb_friends, :force => true do |t|
      t.string :uid, :nil => false
      t.string :name, :nil => false
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :fb_friends
  end
end
