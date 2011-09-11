class AlterInvites3 < ActiveRecord::Migration
  def self.up
    rename_column :invites, :project_id, :inviter_id
  end

  def self.down
    remove_column :invites, :inviter_id, :project_id
  end
end
