class BackOutAddReturnToToProfile < ActiveRecord::Migration
  def self.up
    remove_column :profiles, :return_to_content_after_creation
  end

  def self.down
    add_column :profiles, :return_to_content_after_creation, :integer, :nil => true
  end
end
