class FurtherIndexing < ActiveRecord::Migration
  def self.up
    remove_column :profile_questions,   :question_id
    
    add_index :taggings,                [:taggable_type, :taggable_id]    
    add_index :album_items,             [:album_id, :position]
    add_index :announcements,           :board_id
    add_index :configurations,          :config_key # wtf is this?
    add_index :currency_types,          [:accountable_type, :accountable_id]
    add_index :live_journal_friends,    :account_id
    add_index :votes,                   [:voteable_type, :voteable_id]    
    add_index :profile_questions,       [:profile_id, :position]
    add_index :profile_questions,       [:profile_id, :question_key]
    add_index :monetary_contributions, :announcement_id
    add_index :monetary_contributions, :account_setting_id
    add_index :monetary_contributions, :user_kroog_id

    remove_index :content_stats, :content_id
  end

  def self.down
    add_column :profile_questions, :question_id, :integer
    
    remove_index :taggings,                [:taggable_type, :taggable_id]    
    remove_index :album_items,             [:album_id, :position]
    remove_index :announcements,           :board_id
    remove_index :configurations,          :config_key
    remove_index :currency_types,          [:accountable_type, :accountable_id]
    remove_index :live_journal_friends,    :account_id
    remove_index :votes,                   [:voteable_type, :voteable_id]    
    remove_index :profile_questions,       [:profile_id, :position]
    remove_index :profile_questions,       [:profile_id, :question_key]
    remove_index :monetary_contributions, :announcement_id
    remove_index :monetary_contributions, :account_setting_id
    remove_index :monetary_contributions, :user_kroog_id

    add_index :content_stats, :content_id
  end
end
