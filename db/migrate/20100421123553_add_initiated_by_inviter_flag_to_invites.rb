class AddInitiatedByInviterFlagToInvites < ActiveRecord::Migration
  def self.up
    add_column 'invites', 'initiated_by_invited', :boolean, :null => false, :default => false
  end

  def self.down
  end
end
