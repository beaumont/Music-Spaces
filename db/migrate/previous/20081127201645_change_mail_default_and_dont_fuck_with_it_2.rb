class ChangeMailDefaultAndDontFuckWithIt2 < ActiveRecord::Migration
  def self.up
    change_column(:preferences, :email_notifications, :integer, :limit => 4, :default => 2, :null => false)
  end

  def self.down
    change_column(:preferences, :email_notifications, :integer, :limit => 4, :default => 2, :null => false)
  end
end
