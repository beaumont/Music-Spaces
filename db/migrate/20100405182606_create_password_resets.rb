class CreatePasswordResets < ActiveRecord::Migration
  def self.up
    create_table :password_resets, :force => true do |t|
      t.integer :user_id, :null => false
      t.string :crypted_password, :null => false
      t.timestamps
    end
  end

  def self.down
  end
end
