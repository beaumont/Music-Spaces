class InviteRequestDeniedStateToRejected < ActiveRecord::Migration
  def self.up
    InviteRequest.update_all 'state="rejected"', 'state="denied"'
  end

  def self.down
  end
end
