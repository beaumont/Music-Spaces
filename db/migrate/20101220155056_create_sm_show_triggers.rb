class CreateSmShowTriggers < ActiveRecord::Migration
  def self.up
    create_table :system_messages_show_triggers, :force => true do |t|
      t.integer :user_id, :null => false
      t.string  :system_message_type, :null => false
      t.integer :priority, :null => false, :default => 0
      t.integer :delay
      t.timestamps
    end
  end

  def self.down
  end
end
