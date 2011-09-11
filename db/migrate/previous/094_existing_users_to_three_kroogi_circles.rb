class ExistingUsersToThreeKroogiCircles < ActiveRecord::Migration
  def self.up
    # Push all existing users into 3-circle kroogis
    user_preferences = User.find(:all, :conditions => "type = 'User'", :include => :preference).collect {|x| x.preference}
    user_preferences.compact.each do |pref|
      pref.update_attribute(:full_kroogi_circles, false)
    end
  end

  def self.down
    # Again, not much to do here
  end
end
