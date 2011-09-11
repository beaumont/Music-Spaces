class AddInrainbowsStuffToBetaInviteRequests < ActiveRecord::Migration
  def self.up
    add_column :invites, :album_contribution_id, :integer
  end

  def self.down
    remove_column :invites, :album_contribution_id
  end
end
