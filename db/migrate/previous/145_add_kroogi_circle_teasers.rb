class AddKroogiCircleTeasers < ActiveRecord::Migration

  def self.up
    add_column :user_kroogs, :teaser_db_store_id, :integer
  end

  def self.down
    remove_column :user_kroogs, :teaser_db_store_id
  end

end
