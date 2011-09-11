class CreateActivityLogUsers < ActiveRecord::Migration
  def self.up
    create_table :activity_log_users do |t|
      t.integer :user_id
      t.string  :login
      t.timestamps
    end
  end

  def self.down
    drop_table :activity_log_users
  end
end
