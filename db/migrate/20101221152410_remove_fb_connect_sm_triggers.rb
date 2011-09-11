class RemoveFbConnectSmTriggers < ActiveRecord::Migration
  def self.up
    SystemMessages::ShowTrigger.delete_all
  end

  def self.down
  end
end
