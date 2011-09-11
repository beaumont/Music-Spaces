class ImproveCaching < ActiveRecord::Migration
  def self.up
    add_index :contents,          [:type, :created_at]
    add_index :relationships,     [:relationshiptype_id, :user_id]
    add_index :account_settings,  :user_id
    add_index :accounts,          :user_id
    add_index :comments,          [:commentable_type, :commentable_id]
    add_index :contents,          :user_id
    add_index :activity_counts,   [:user_id, :activity_count_id]
    add_index :favorites,         [:user_id, :created_at]
    add_index :playlists,         [:id, :user_id, :session_id, :name]
    remove_index :playlists,      ["user_id", "session_id", "name"]
    add_index :featured_items,    [:currently_featured, :is_content, :is_project],          :name => 'featured_item_idx'
    add_index :invites,           [:inviter_id, :invitation_type, :activated_at],           :name => 'invite_idx'
    add_index :activities,        [:user_id, :from_user_id, :activity_count_id, :status],   :name => 'activity_idx'
  end

  def self.down
    remove_index :contents,         [:type, :created_at]
    remove_index :relationships,    [:relationshiptype_id, :user_id]
    remove_index :account_settings, :user_id
    remove_index :accounts,         :user_id
    remove_index :comments,         [:commentable_type, :commentable_id]
    remove_index :contents,         :user_id
    remove_index :activity_counts,  [:user_id, :activity_count_id]    
    remove_index :favorites,        [:user_id, :created_at]
    remove_index :playlists,        [:id, :user_id, :session_id, :name]
    add_index :playlists,           ["user_id", "session_id", "name"]
    
    say '***'
    say "* Will have to manually remove these indexes -- migration errors out on custom names (normal names too long)"
    say '***'
    remove_index :invites,          'invite_idx'
    remove_index :activities,       'activity_idx'
    remove_index :featured_items,   'featured_item_idx'
  end
end
