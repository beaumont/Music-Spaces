class AddFbLikeConsolidationColumnToUser < ActiveRecord::Migration
  def self.up
    unless RAILS_ENV == 'production'
      add_column :users, :fb_like_consolidation, :string
    end
  end

  def self.down
    unless RAILS_ENV == 'production'
      remove_column :users, :fb_like_consolidation
    end
  end
end
