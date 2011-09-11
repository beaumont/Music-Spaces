class IndexUsersByOnBehalfId < ActiveRecord::Migration
  def self.up
    add_index "users", ["on_behalf_id"], :name => "index_users_on_on_behalf_id"    
  end

  def self.down
  end
end
