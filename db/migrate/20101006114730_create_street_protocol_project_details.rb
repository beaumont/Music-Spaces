class CreateStreetProtocolProjectDetails < ActiveRecord::Migration
  def self.up
    create_table :street_protocol_project_details, :force => true do |t|
      t.integer :content_id, :null => false
      t.string :short_description
      t.string :short_description_ru
      t.date :end_date
      t.integer :related_content_id
      t.integer :participated_count
      t.decimal :goal_amount, :precision => 10, :scale => 2, :default => 0
      t.decimal :currently_collected, :precision => 10, :scale => 2, :default => 0
      t.timestamps
    end
  end

  def self.down
  end
end
