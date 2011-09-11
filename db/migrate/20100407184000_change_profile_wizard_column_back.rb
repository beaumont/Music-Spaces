class ChangeProfileWizardColumnBack < ActiveRecord::Migration
  def self.up
    change_column('profiles', :wizard_completed, :boolean, :default => 0)
    profiles = Profile.find(:all, :conditions => "wizard_completed = 2")
    profiles.compact.each do |profile|
      profile.update_attribute(:wizard_completed, 1)
    end
  end

  def self.down
    change_column('profiles', 'wizard_completed', :integer, :default => 0)
  end

end
