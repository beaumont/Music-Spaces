class UserCanAllowGuestComments < ActiveRecord::Migration
  def self.up
    add_column :rare_user_settings, :allows_guest_comments, :boolean
  end

  def self.down
  end
end
