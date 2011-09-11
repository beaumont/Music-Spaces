class MakeAccountsCryptedPasswordString < ActiveRecord::Migration
  def self.up
    #it was :text, not intentionally I guess
    change_column :accounts, :crypted_password, :string, :null => false
  end

  def self.down
  end
end
