class CleanUpFaves < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute "delete from favorites where favorable_type in ('User','Project')"
  end

  def self.down
  end
end