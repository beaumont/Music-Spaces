class MigrateProfileTypes < ActiveRecord::Migration
  def self.up
    
    mappy = {
      :RegularUser => {:id => 0, :name => 'Regular user'.t, :account_type_id => 0}, 
      :Musician => {:id => 1, :name => 'Musician'.t, :account_type_id => 0}, 
      :Promoter => {:id => 2,  :name => 'Promoter'.t, :account_type_id => 0, :position => 5}, 
      :IndustryPro => {:id => 3, :name => 'Music Industry professional'.t, :account_type_id => 0, :position => 2}, 
      :Artist => {:id => 4, :name => 'Visual Artist'.t, :account_type_id => 0, :position => 3}, 
      :Photographer => {:id => 5, :name => 'Photographer'.t,:account_type_id => 0, :position => 4},
      :Band => {:id => 6, :name => 'Music Project/Collaboration'.t, :account_type_id => 1, :position => 1},
      :Studio => {:id => 7, :name => 'Studio'.t, :account_type_id => 1, :position => 2},
      :Label => {:id => 8, :name => 'Label'.t, :account_type_id => 1, :position => 3},
      :Venue => {:id => 9, :name => 'Venue'.t, :account_type_id => 1},
      :Other => {:id => 10, :name => 'Project/Collaboration'.t, :account_type_id => 1}
    }
    
    
    Profile.find(:all).each do |profile|
      puts "Profile:#{profile.id}"
      
      profile_types = ProfileType.find(:all, :conditions => {:profile_id => profile.id})
      profile_types_names = []
      profile_types.each do |profile_type|
        found_arr = ((mappy.find {|key_val| key_val[1][:id] == profile_type.profile_name_id}) || [:uknown, {}])
        profile_types_names << (found_arr[1][:name] || found_arr[0].to_s)
      end
      
      profile.tag_list = profile_types_names.join(", ")
      profile.save!
      
    end
    
  end
  

  def self.down
    Profile.find(:all).each do |profile|
      puts "Profile:#{profile.id}"
      profile.tag_list = ''
      profile.save!
    end
  end
end