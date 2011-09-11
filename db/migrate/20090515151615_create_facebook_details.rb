class CreateFacebookDetails < ActiveRecord::Migration
  def self.up
    create_table :fb_user_details do |t|
      t.belongs_to :user
      t.integer :fb_user_id, :limit => 8
      t.string :fb_session_key
    end
  end

  def self.down
    drop_table :fb_user_details
  end
end
