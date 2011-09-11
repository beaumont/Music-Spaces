class MoveFbLikeConsolidationColumnFromUsersToPreferences < ActiveRecord::Migration
  def self.up
    unless RAILS_ENV == 'production'
      remove_column :users, :fb_like_consolidation
    end
    add_column :preferences, :fb_like_consolidation, :string
  end

  def self.down
    remove_column :preferences, :fb_like_consolidation
  end
end
