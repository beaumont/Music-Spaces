class AddReturnToToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :return_to_content_after_creation, :integer, :nil => true
    add_column :profiles, :wizard_completed, :boolean, :default => false
    Profile.update_all ['wizard_completed=?', true]
  end

  def self.down
    remove_column :profiles, :return_to_content_after_creation
    remove_column :profiles, :wizard_completed
  end
end
