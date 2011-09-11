class CreateProfileTypes < ActiveRecord::Migration
  def self.up
    
    create_table :profile_types, :options => 'TYPE=MyISAM', :force => true do |t|
      t.column :profile_id,                   :integer, :default => 1, :null => false
      t.column :user_id,                      :integer, :default => 1, :null => false
      t.column :profile_name_id,              :integer
    end
    
    # Profile.find(:all).each do |profile|
    #     profile_type = ProfileType.new(:profile_name_id => 1, :user_id => profile.user_id)
    #     profile.profile_types << profile_type
    #     profile.save
    # end
    
  end

  def self.down
    drop_table :profile_types
  end
end
