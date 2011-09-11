class CreateSmResponses < ActiveRecord::Migration
  def self.up
    create_table :system_messages_responses do |t|
      t.string :type, :null => true
      t.integer :user_id, :null => false
      t.string  :system_message_type, :null => false
      t.timestamps
    end
  end

  def self.down
  end
end
