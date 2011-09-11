class AddStateToInvites < ActiveRecord::Migration
  def self.up
    # It's about time these column names matches what they really do
    rename_column :invites, :activated_at, :accepted_at
    rename_column :invites, :invitation_type, :circle_id
    
    Invite.update_all 'state="reinvited"', 'reinvited_at IS NOT NULL'
    Invite.update_all 'state="rejected"', 'rejected_at IS NOT NULL'
    Invite.update_all 'state="accepted"', 'accepted_at IS NOT NULL'
  end

  def self.down
    rename_column :invites, :accepted_at, :activated_at
    rename_column :invites, :circle_id, :invitation_type
  end
end
