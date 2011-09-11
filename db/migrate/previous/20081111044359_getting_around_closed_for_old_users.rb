class GettingAroundClosedForOldUsers < ActiveRecord::Migration
  def self.up
    Preference.update_all 'getting_around_open=0'
  end

  def self.down
  end
end
