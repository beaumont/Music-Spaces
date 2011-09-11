class ChangeMailDefaultAndDontFuckWithIt < ActiveRecord::Migration
  def self.up
    change_column(:preferences, :email_notifications, :boolean, :default => 2, :null => false)
  end

  def self.down
    change_column(:preferences, :email_notifications, :boolean, :default => 2, :null => false)
  end
end
