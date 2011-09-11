class MigrateUserDataForVariableNumKroogiCircles < ActiveRecord::Migration
  def self.up
    # Force relationship types 2,3,4 => 2, but only for users (projects can stay)
    project_ids = Project.find(:all).map(&:id)
    Relationship.update_all 'relationshiptype_id = 2', ["relationshiptype_id in (3,4) and user_id not in (?)", project_ids]
    
    # Force all users not in accepted contexts to the general context
    user_preferences = User.find(:all, :conditions => "type = 'User'", :include => :preference).collect {|x| x.preference}
    user_preferences.compact.each do |pref|
      pref.update_attribute(:name_context, 'general') 
    end
  end

  def self.down
    # As for the data: nada to be done... we can't tell which circles users used to be in, so just let 'em stay where they are    
  end
end
