class AlterInvites < ActiveRecord::Migration
  def self.up
    remove_column :invites, :invitation_type
    add_column :invites, :invitation_type, :integer
    add_column :invites, :updated_at, :datetime
    add_column :invites, :reinvited_at, :datetime
    Project.delete_all
  end

  def self.down
    remove_column :invites, :updated_at
    remove_column :invites, :reinvited_at
    remove_column :invites, :invitation_type
    add_column :invites, :invitation_type, :string
  end
end
