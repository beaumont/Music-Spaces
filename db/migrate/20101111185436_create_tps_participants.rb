class CreateTpsParticipants < ActiveRecord::Migration
  def self.up
    create_table :tps_participants, :force => true do |t|
      t.integer :content_id, :null => false
      t.integer :user_id, :null => false
      t.string :first_name
      t.string :last_name
      t.string :document_kind
      t.string :document_identifier
      t.string :address
      t.boolean :address_missing
      t.boolean :document_missing
      t.string :state, :null => false
      t.timestamps
    end
    add_index(:tps_participants, [:content_id, :user_id], :unique => true)
  end

  def self.down
  end
end
