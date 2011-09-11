class AddCurrentLocaleToPreferences < ActiveRecord::Migration
  def self.up
    add_column :preferences, :current_locale, :string, :limit => 10
  end

  def self.down
  end
end
