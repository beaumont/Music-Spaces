class KillObservers < ActiveRecord::Migration
  def self.up
    Invite.delete_all "invitation_type = '5'"
  end

  def self.down
  end
end
