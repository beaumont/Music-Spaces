class UserCanHideEmailFromSearchesInPreferences < ActiveRecord::Migration
  def self.up
    remove_column :users, :email_searchable rescue nil
    add_column :preferences, :email_searchable, :boolean, :default => 0
    Preference.update_all('email_searchable = 1')
  end

  def self.down
  end
end
