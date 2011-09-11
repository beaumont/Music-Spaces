class AddJoinInviterFlagToInvites < ActiveRecord::Migration
  def self.up
    add_column 'invites', 'join_inviter_to_invited', :boolean, :null => false, :default => false
  end

  def self.down
  end
end
