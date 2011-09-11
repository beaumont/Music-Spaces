class FixMovableBrokerMonetaryProcessorEntry < ActiveRecord::Migration
  def self.up
    execute("UPDATE monetary_processors SET short_name = 'movable_broker' WHERE name = 'SMS';")
  end

  def self.down
    # No down.  This is a fix for a typo in previous migrations, not a functional fix.
  end
end
