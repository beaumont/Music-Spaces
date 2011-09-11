class AddNamingContextToPreferences < ActiveRecord::Migration
  def self.up
    add_column :preferences, :name_context, :string, :default => 'general'
  end

  def self.down
    remove_column :preferences, :name_context
  end
end
