class UpdateUserKroogsColumns < ActiveRecord::Migration
  def self.up
    change_column :user_kroogs, :created_at, :datetime, :default => '1970-01-01 00:00:00', :null => false
    change_column :user_kroogs, :updated_at, :datetime, :default => '1970-01-01 00:00:00', :null => false
    change_column :user_kroogs, :created_by_id, :integer, :default => 0, :null => false
    change_column :user_kroogs, :updated_by_id, :integer, :default => 0, :null => false
  end

  def self.down
  end
end