class AlterProfiles4 < ActiveRecord::Migration
  def self.up
      User.find(:all).each do |user|
          user.profile = Profile.new
          user.save_with_validation(false)
      end
    Profile.update_all 'account_type_id =0'
  end

  def self.down
    
  end
end