class UpdateInviteQuotaForRelease < ActiveRecord::Migration
  def self.up
    # We're setting invite quota to 5 to start with
    Profile.update_all 'invite_quota=5'
    say "Set all invite quotas to 5"
    
    # Give admin users many many invites
    User.find(:all).each do |user|
      if user.in_role?(Role::ADMIN)
        user.profile.update_attribute(:invite_quota, '9999')
      end
    end
    say "Gave admins lots and lots of invites"
    
    
  end

  def self.down
  end
end
