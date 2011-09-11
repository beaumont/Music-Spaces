class ModifyInviteCols < ActiveRecord::Migration
  def self.up
    add_column :invites, :privacylevel, :integer,  :default => 0, :null => false, :limit => 4
  end

  def self.down
    remove_column :invites, :privacylevel
  end
end
