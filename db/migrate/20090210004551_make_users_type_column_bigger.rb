class MakeUsersTypeColumnBigger < ActiveRecord::Migration
  def self.up
    change_column :users, :type, :string, :limit => 30
  end

  def self.down
  end
end
