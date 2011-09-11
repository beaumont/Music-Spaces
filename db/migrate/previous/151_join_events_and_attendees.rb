class JoinEventsAndAttendees < ActiveRecord::Migration
  def self.up
    create_table :events_users, :id => false do |t|
      t.belongs_to :user, :event
    end
    add_index :events_users, [:user_id,:event_id]
    add_index :admission_pass_name_list, :name
  end

  def self.down
    remove_index :admission_pass_name_list, :name
    remove_index :events_users, [:user_id,:event_id]
    drop_table :events_users
  end
end
