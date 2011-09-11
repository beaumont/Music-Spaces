class FixingPermissionsLikeWhoa < ActiveRecord::Migration
  def self.up    
    # Wow... permissions are ALL messed up
    
    puts "Fixing permissions for all content items -- might take a while"
    Content.find(:all).each do |c|
      
      # Assume current listings restricted to interested circle really mean public, because they aren't using the everyone/nobody values
      if c.restriction_level == 5
        ActiveRecord::Base.connection.execute("delete contents_relationshiptypes.* from contents_relationshiptypes where contents_relationshiptypes.content_id=#{c.id}")
        c.relationshiptypes << Relationshiptype.find(Relationshiptype.everyone)
        c.save!
      end
      
    end
    
  end

  def self.down
  end
end
