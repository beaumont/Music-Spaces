class FixForKdUsersFlag < ActiveRecord::Migration
  def self.up
    Facebook::UserDetails.update_all('is_kd_user = 1', 'is_kd_user = 0')
  end

  def self.down
  end
end
