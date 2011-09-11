class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.column :user_id,                   :integer, :default => 1, :null => false
      t.column :email_notifications,       :boolean, :default => 0, :null => false
    end
    add_index(:preferences, :user_id, :unique => true)
    User.find(:all).each do |user|
        user.preference = Preference.new(:email_notifications => 1)
        user.save_with_validation(false)
    end
  end

  def self.down
    drop_table :preferences
  end
end
