class AddShowBirthdateFieldToUsers < ActiveRecord::Migration
  def self.up
    add_column 'users', 'birthdate_visiblity', :boolean, :default => false
  end

  def self.down
    remove_column 'users', 'birthdate_visiblity'
  end
end
