class ConvertExistingInvitesToThreeCircles < ActiveRecord::Migration
  def self.up
    # FOR INVITES: Force relationship types 2,3,4 => 2, but only for users (projects can stay)
    project_ids = Project.find(:all).map(&:id)
    if project_ids.empty?
      Invite.update_all 'invitation_type = 2', "invitation_type in (3,4)"
    else
      Invite.update_all 'invitation_type = 2', ["invitation_type in (3,4) and inviter_id not in (?)", project_ids]
    end

  end

  def self.down
  end
end
