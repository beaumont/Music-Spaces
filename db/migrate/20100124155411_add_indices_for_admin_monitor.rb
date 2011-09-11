class AddIndicesForAdminMonitor < ActiveRecord::Migration
  def self.up
    return if RAILS_ENV == 'production' #already applied it there manually
    add_index :activities, :created_at
    add_index :monetary_transactions, :created_at, name => 'mt_created_at'
    add_index :users, :created_at
    add_index :users, :activated_at
    add_index :comments, :created_at
  end

  def self.down
  end
end
