class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :max_attendees
      t.string :title
      t.datetime :start_date
      t.datetime :end_date
      t.text :description
      t.integer :category, :limit => 2
      t.string :homepage
      t.integer :number_of_guests
      t.belongs_to :board
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
