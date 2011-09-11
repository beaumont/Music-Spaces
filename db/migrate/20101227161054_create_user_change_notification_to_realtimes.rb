class CreateUserChangeNotificationToRealtimes < ActiveRecord::Migration
  def self.up
    create_table :user_change_notification_to_realtimes, :force => true do |t|
      t.string  :login, :default => ""
      t.integer :user_id
      t.boolean :deleted, :default => false
      t.string  :token, :default => ""
      t.timestamps
    end
  end

  def self.down
    drop_table :user_change_notification_to_realtimes
  end
end
