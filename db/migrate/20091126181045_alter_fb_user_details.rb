class AlterFbUserDetails < ActiveRecord::Migration
  def self.up
    add_column :fb_user_details, :linked_artist_id, :integer, :null => true
    add_column :fb_user_details, :header_text, :text, :null => true
  end

  def self.down
    remove_column :fb_user_details, "linked_artist_id"
    remove_column :fb_user_details, "header_text"
  end
end
