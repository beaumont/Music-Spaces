class AddingCircleLevelRestrictionForInboxVoting < ActiveRecord::Migration
  def self.up
    add_column :extra_inbox_fields, :voting_restriction, :integer, :default => -2
  end

  def self.down
    remove_column :extra_inbox_fields, :voting_restriction
  end
end
