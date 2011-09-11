class AddFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column 'users', 'gender', :string, :limit => 1
    add_column 'users', 'language', :string, :limit => 10
    add_column 'users', 'birthdate', :date
  end

  def self.down
  end
end
