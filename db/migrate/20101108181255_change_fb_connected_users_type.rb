class ChangeFbConnectedUsersType < ActiveRecord::Migration
  def self.up
    users = Facebook::User.find(:all, :joins => :details, :conditions => 'fb_user_details.is_fb_connected = 1')
    users.each do |user|
      user.change_type!(BasicUser)
    end
  end

  def self.down
  end
end
