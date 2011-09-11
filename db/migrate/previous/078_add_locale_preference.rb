class AddLocalePreference < ActiveRecord::Migration
  def self.up
    add_column :preferences, :email_locale, :string, :default => 'en'
  end

  def self.down
    remove_column :preferences, :email_locale
  end
end
