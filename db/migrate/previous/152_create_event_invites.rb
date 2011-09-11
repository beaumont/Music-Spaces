class CreateEventInvites < ActiveRecord::Migration
  def self.up
    create_table :event_invites do |t|
      t.belongs_to :user, :event
      t.string :event_access_key
      t.text :message
      t.string :rsvp, :null => true
      t.timestamps
    end
    add_index :event_invites, [:user_id,:event_id]
    drop_table :events_users
    remove_column :monetary_contributions, :event_access_key
  end

  def self.down
    add_column :monetary_contributions, :event_access_key, :string
    remove_index :event_invites, [:user_id,:event_id]
    
    create_table "events_users", :id => false, :force => true do |t|
      t.integer "user_id"
      t.integer "event_id"
    end
    
    drop_table :event_invites
  end
end
