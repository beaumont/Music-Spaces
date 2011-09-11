class MakeDbStoreContentLarger < ActiveRecord::Migration
  def self.up
    change_column(:db_store, :content, :text, :limit => 2.megabytes) unless RAILS_ENV == 'production' #applied there manually already
  end

  def self.down
  end
end
