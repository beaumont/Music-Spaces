class AddDefaultBirthdate < ActiveRecord::Migration
  def self.up
    User.update_all ['birthdate=?, birthdate_visiblity=?', Date.new(y=1674,m=1,d=1), '0'], 'birthdate is null'
  end

  def self.down
  end
end
