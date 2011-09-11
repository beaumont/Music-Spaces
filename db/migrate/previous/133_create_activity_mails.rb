class CreateActivityMails < ActiveRecord::Migration
  def self.up
    create_table :activity_mails do |t|
      t.integer :activity_id
      t.integer :user_id
      t.timestamps
    end
    add_index :activity_mails,  [:user_id, :created_at]
    add_index :activity_mails,  [:activity_id]
  end

  def self.down
    drop_table :activity_mails
  end
end
