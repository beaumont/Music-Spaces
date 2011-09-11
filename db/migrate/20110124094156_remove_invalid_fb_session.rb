class RemoveInvalidFbSession < ActiveRecord::Migration
  def self.up
    Facebook::UserDetails.update_all("fb_session_key = NULL", "is_fb_connected = 1 AND fb_session_key IS NOT NULL")
  end

  def self.down
  end
end
