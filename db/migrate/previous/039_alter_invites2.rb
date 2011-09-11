class AlterInvites2 < ActiveRecord::Migration
  def self.up
    add_column :invites, :rejected_at, :datetime
  end

  def self.down
    remove_column :invites, :rejected_at
  end
end
