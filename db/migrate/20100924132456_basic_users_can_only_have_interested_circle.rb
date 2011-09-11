class BasicUsersCanOnlyHaveInterestedCircle < ActiveRecord::Migration
  def self.up
    update("update relationships r inner join users u on u.id = r.user_id and u.type = 'BasicUser' and relationshiptype_id < 5 set r.relationshiptype_id = 5")
  end

  def self.down
  end
end
