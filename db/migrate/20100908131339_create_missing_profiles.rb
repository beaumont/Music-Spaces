class CreateMissingProfiles < ActiveRecord::Migration
  def self.up
    return if RAILS_ENV == 'production'
    Project.active.each do |p|

      unless p.profile
        p.profile = Profile.new(:account_type_id => Profile::PROJECT)
      end
      
      unless p.account_setting
        p.account_setting = AccountSetting.new
      end

      begin
        p.save_without_validation!
      rescue => e
        puts "failed on project #{p.login}"
        raise e
      end

    end
  end

  def self.down
  end
end
