class CreateTpsParticipantInfoRequests < ActiveRecord::Migration
  def self.up
    create_table :tps_participant_info_requests, :force => true do |t|
      t.integer :participant_id, :null => false
      t.boolean :address_needed, :null => false
      t.boolean :document_needed, :null => false
      t.boolean :answered, :null => false, :default => false
      t.string :first_name
      t.string :last_name
      t.string :document_kind
      t.string :document_identifier
      t.string :address
      t.timestamps
    end
    add_index :tps_participant_info_requests, :participant_id
  end

  def self.down
  end
end
