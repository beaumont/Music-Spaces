class HiddenProjects < ActiveRecord::Migration

  # renaming is_private for consistency with standards
  # used to do more, but that functionality got reverted
  
  def self.up
    rename_column :users, :is_private, :private
  end

  def self.down
    rename_column :users, :private, :is_private
  end
end
