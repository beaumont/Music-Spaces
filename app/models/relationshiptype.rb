# == Schema Information
# Schema version: 20081006211752
#
# Table name: relationshiptypes
#
#  id                         :integer(11)     default(0), not null, primary key
#  name                       :string(255)
#  restricted                 :integer(4)      default(0), not null
#  position                   :integer(4)      default(0), not null
#  explanation_db_store_id    :integer(11)
#  explanation_db_store_ru_id :integer(11)
#

class Relationshiptype < ActiveRecord::Base

  translates_virtual_attribute :explanation
    
  TYPES = {:founders => 0,
    :family => 1,
    :backstage => 2,
    :frontrow => 3,
    :fanclub => 4,
    :interested => 5,
    # NOTE: type 6 is site invite
  }
        
  def self.all_valid
    TYPES.values.sort
  end
        
  def self.circle_and_further(cid)
    cid = cid.circle_id if cid.is_a?(UserKroog)
    (cid.to_i..(TYPES.values.max)).select{|x| TYPES.values.include?(x)}
  end
    
  def self.circle_and_closer(cid)
    cid = cid.circle_id if cid.is_a?(UserKroog)
    ((TYPES.values.min)..cid.to_i).select{|x| TYPES.values.include?(x)}
  end
    
  def self.followers_and_founders_types
    TYPES.reject{|type, id| (id < 0 || id > 5)}.values
  end

  def self.closer_circle_types
    [2, 3, 4]
  end
    
  # followers do not include founders, but include those who watch me
  def self.follower_types
    TYPES.reject{|type, id| (id < 1 || id > 5)}.values
  end
    
  def self.by_invite_only
    TYPES.reject{|type, id| (id < 0 || id > 4)}.values
  end

  def self.by_invite_only_without_founders
    TYPES.reject{|type, id| (id < 1 || id > 4)}.values
  end

  class << self
    TYPES.each {|key, value|
      self.class_eval do
        define_method :"#{key}" do
          TYPES[key]
        end
      end
    }
  end

  def self.friends
    TYPES[:backstage]
  end
    
  def self.nobody
    -1
  end
    
  def self.everyone
    -2
  end
  
end

