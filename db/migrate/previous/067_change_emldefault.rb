class ChangeEmldefault < ActiveRecord::Migration
  def self.up
    change_column(:preferences, :email_notifications, :boolean, :default => 1, :null => false)
  end

  def self.down
    change_column(:preferences, :email_notifications, :boolean, :default => 0, :null => false)
  end
  
end
