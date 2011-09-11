class AddKarmaReferredUser < ActiveRecord::Migration
  def self.up
    add_column :karma_points, :referred_id, :integer # the user who was referred
  end

  def self.down
    remove_column :karma_points, :referred_id
  end
end
