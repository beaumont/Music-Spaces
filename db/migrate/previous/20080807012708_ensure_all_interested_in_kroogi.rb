class EnsureAllInterestedInKroogi < ActiveRecord::Migration
  def self.up
    recent = User.find(:all, :conditions => ['type=? and created_at>?', 'User', 1.month.ago])
    kroog = User.kroogi
    
    recent.each do |u|
      unless Relationship.has_follower?(kroog, u, Relationshiptype::TYPES[:interested])
        Relationship.create_kroogi_relationship(:from_user => kroog, :to_user => u, :type => :interested)
      end
    end
  end

  def self.down
  end
end