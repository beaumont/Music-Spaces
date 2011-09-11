class IndexUsersByEmail < ActiveRecord::Migration
  def self.up
    return if RAILS_ENV == 'production' #already there
    execute 'alter table users add index index_users_on_email (email)'
  end

  def self.down
  end
end
