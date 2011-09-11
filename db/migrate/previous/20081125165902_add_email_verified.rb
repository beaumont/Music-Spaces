class AddEmailVerified < ActiveRecord::Migration
  def self.up
    add_column :users, :email_verified, :string, :default => nil, :nil => true
    User.activated.each{|u| u.update_attribute(:email_verified, u.email)}
  end

  def self.down
    remove_column :users, :email_verified
  end
end
