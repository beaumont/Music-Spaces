class CreateRelationships < ActiveRecord::Migration
  def self.up
    anyone = Relationshiptype.find(-2)
    Content.find(:all, :conditions => "parent_id is null").each do |content|
      puts "Content:#{content.title}"
      content.relationshiptypes << anyone
      content.save
    end
    
    
    User.find(:all).each do |user|
      puts "User:#{user.login}"
      # users that this person is watching
      friends = Favorite.find(:all, :conditions => [ "user_id = ? AND (favorable_type = 'User' OR favorable_type = 'Project')", user.id])
      friends.each do |favorite|
        r = Relationship.new(:user_id => user.id, :related_user_id => favorite.favorable_id, :related_entity_id => favorite.favorable_id, :relationshiptype_id => 7)
        r.save
      end
      # users that watch this user
      watched_by = Favorite.find(:all, :conditions => [ "favorable_id = ? AND (favorable_type = 'User' OR favorable_type = 'Project')", user.id])
      watched_by.each do |favorite|
        r = Relationship.new(:user_id => user.id, :related_user_id => favorite.user_id, :related_entity_id => favorite.user_id, :relationshiptype_id => 5)
        r.save
      end
      
      Invite.find(:all, :conditions => ["inviter_id = ? AND invitation_type in  (0, 1, 2, 3, 4) and activated_at is not null and rejected_at is null", user.id]).each do |invite|
        r = Relationship.new(:user_id => user.id, :related_user_id => invite.user_id, :related_entity_id => invite.id, :relationshiptype_id => invite.invitation_type)
        r.save
      end
      
    end
    
    #drop_table :projects_users
    
  end
  

  def self.down
    Relationship.delete_all
    Content.find(:all, :conditions => "parent_id is null").each do |content|
      content.relationshiptypes.clear
      content.save
    end
  end
end
