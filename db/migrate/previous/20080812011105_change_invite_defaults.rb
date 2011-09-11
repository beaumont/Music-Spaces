class ChangeInviteDefaults < ActiveRecord::Migration
  def self.up
    change_column :invites, :free, :boolean, :default => nil, :null => true
  end

  def self.down
  end
end
