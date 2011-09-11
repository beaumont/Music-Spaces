class CreateVenues < ActiveRecord::Migration
  def self.up
    create_table :venues do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.string :homepage
      t.boolean :house_party, :default => false
      t.timestamps
    end
    
    create_table :events_venues, :id => false do |t|
      t.belongs_to :event, :venue
    end
  end

  def self.down
    drop_table :venues
    drop_table(:events_venues) if ActiveRecord::Base.connection.tables.include?("events_venues")
  end
end
