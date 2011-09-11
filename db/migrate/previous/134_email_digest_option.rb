class EmailDigestOption < ActiveRecord::Migration
  def self.up
    change_column :preferences, :email_notifications, :integer, :default => 2
    # When migrating from boolean, accept mail becomes digest, not immediate
    Preference.update_all 'email_notifications=2', 'email_notifications=1'
  end

  def self.down
    change_column :preferences, :email_notifications, :boolean, :default => true
  end
end
