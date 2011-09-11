class DropEventsVenuesAndMakeHasOne < ActiveRecord::Migration
  def self.up
    drop_table :events_venues
    add_column :events, :venue_id, :integer
  end

  def self.down
    create_table "events_venues", :id => false, :force => true do |t|
      t.integer "event_id"
      t.integer "venue_id"
    end
    remove_column :events, :venue_id    
  end
end
