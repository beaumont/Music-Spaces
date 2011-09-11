class AddStateToInviteRequest < ActiveRecord::Migration
  def self.up
    add_column :invite_requests, :state, :string, :default => 'pending'
    add_column :invite_requests, :invitation_id, :integer, :null => true
    add_column :invites, :state, :string, :default => 'pending'
    
    # NO INDEX because never used in current code
    # add_index :invite_requests, :invitation_id
    add_index :invites, :state
  end

  def self.down
    remove_column :invite_requests, :state, :string
    remove_column :invite_requests, :invitation_id 
    remove_column :invites, :state
  end
end
