class RenameKroogiSettings < ActiveRecord::Migration
  def self.up
    drop_table :user_kroogs
    rename_table :kroogi_settings, :user_kroogs
    rename_column :user_kroogs, :invitation_type, :relationshiptype_id
    
  end

  def self.down
    rename_column :user_kroogs, :relationshiptype_id, :invitation_type
    rename_table :user_kroogs, :kroogi_settings
  end
end