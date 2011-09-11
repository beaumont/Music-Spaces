class UserCanHaveWallNotesTabIndex < ActiveRecord::Migration
  def self.up
    add_column :rare_user_settings, :wall_notes_tab_index, :integer, :limit => 1        
  end

  def self.down
  end
end
