class StopDuplicateInvitations < ActiveRecord::Migration
  def self.up
    # We now rely on activated_at column, but it wasn't being set before.  Fixes this logic.
    # this is very wrong. we can have unaccepted invites, thats for sure
    # Invite.update_all ["activated_at=?", Time.now], "activated_at is null and user_id is not null and user_id <> '' and display_name is not null and display_name <> ''"
  end

  def self.down
  end
end
