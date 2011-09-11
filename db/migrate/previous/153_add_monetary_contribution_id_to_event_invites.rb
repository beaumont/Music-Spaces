class AddMonetaryContributionIdToEventInvites < ActiveRecord::Migration
  def self.up
    add_column :event_invites, :monetary_contribution_id, :integer
    add_index :event_invites, :monetary_contribution_id
  end

  def self.down
    remove_index  :event_invites, :monetary_contribution_id
    remove_column :event_invites, :monetary_contribution_id
  end
end
