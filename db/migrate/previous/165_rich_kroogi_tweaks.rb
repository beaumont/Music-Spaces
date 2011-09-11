class RichKroogiTweaks < ActiveRecord::Migration
  def self.up
    Relationshiptype.find_by_id(5).update_attribute(:explanation, "Use this circle for people who are willing to express their interest in you and simply read your updates on their homepage. This circle is always available for anyone to join.")
    
    # Switch out of attribute bits to own column, b/c can request to join any arbitrary circle
    create_table :invite_requests, :force => true do |t|
      t.integer :user_id, :circle_id, :wants_to_join_id
      t.timestamps
    end
    add_index :invite_requests, :wants_to_join_id
    
    remove_column :account_settings, :allow_invite_requests
  end

  def self.down
    drop_table :invite_requests
    add_column :account_settings, :allow_invite_requests, :boolean
  end
end
