# == Schema Information
# Schema version: 20081126233441
#
# Table name: user_kroogs
#
#  id                    :integer(11)     not null, primary key
#  user_id               :integer(11)     not null
#  relationshiptype_id   :integer(11)
#  price                 :decimal(10, 2)
#  created_at            :datetime        not null
#  updated_at            :datetime        not null
#  created_by_id         :integer(11)     not null
#  updated_by_id         :integer(11)     not null
#  teaser_db_store_id    :integer(11)
#  name                  :string(255)
#  open                  :boolean(1)      default(TRUE)
#  can_request_invite    :boolean(1)
#  name_ru               :string(255)
#  name_fr               :string(255)
#  teaser_db_store_ru_id :integer(11)
#

class UserKroog < ActiveRecord::Base
  # belongs_to :teaser_db_store, :class_name => 'DbStore'
  belongs_to :user
  has_one :donation_setting, :as => :accountable, :dependent => :destroy
  has_one :monetary_donation
  include DonationSettingMethods

  xss_terminate :except => [:teaser]

  attr_accessor :teaser, :wants_to_be_paid
  alias_method :wants_to_be_paid?, :wants_to_be_paid
  attr_reader :circle_id
  acts_as_threaded
  acts_as_permitted
  
  translates :name, :base_as_default => true
  translates_virtual_attribute :teaser, :base_as_default => true

  def validate
    raise("Invalid relationship type") unless Relationshiptype.all_valid.include?(self.relationshiptype_id)
  end

  def before_save
    # Interested circle must ALWAYS be open to everyone
    if self.relationshiptype_id == 5
      self.open = true
      self.can_request_invite = true
    end
    
    clear_amounts
    logger.debug "[SAVING KROOG]"
    self.donation_setting_object.save
    self
  end

  def before_create
    # Set defaults
    case relationshiptype_id
    when 0..1
      self.open = false
      self.can_request_invite = false
    when 2..4
      self.open = false
      self.can_request_invite = true
    when 5
      self.open = true
      self.can_request_invite = true
    end
    self
  end

  alias_method :name_with_globalize, :name
  def name
    _name.blank? ? user.generic_circle_name(self.relationshiptype_id) : name_with_globalize
  end
  alias_method :circle_name, :name
  
  
  def members
    Relationship.find_followers(self.user, [self.relationshiptype_id], :limit => nil)
  end

  def members_include?(user)
    Relationship.has_follower?(self.user, user, [self.relationshiptype_id])
  end

  def members_count
    @members_count ||= Relationship.count_followers(self.user, [self.relationshiptype_id])
  end
  
  def invites
    user.invites.invites_to(self).pending
  end
  
  # Wrap up find_or_create logic
  def self.get_by_user_and_circle(user, relationshiptype_id)
    relationshiptype_id = relationshiptype_id.is_a?(Symbol) && Invite::TYPES[relationshiptype_id] ? Invite::TYPES[relationshiptype_id][:id] : relationshiptype_id.to_i
    raise "Invalid relationshiptype #{relationshiptype_id} for user #{user.id}" unless user.all_circle_ids.include?(relationshiptype_id) || relationshiptype_id == Relationshiptype.founders
    
    kroog = UserKroog.find_by_user_id_and_relationshiptype_id(user.id, relationshiptype_id)
    kroog ||= UserKroog.create(:user_id => user.id, :relationshiptype_id => relationshiptype_id)
    return kroog
  end

  def closer_circles
    self.user.circles.select{|x| x.relationshiptype_id < self.relationshiptype_id }
  end
  
  def further_circles
    self.user.circles.select{|x| x.relationshiptype_id > self.relationshiptype_id }
  end

  # def teaser=(data)
  #   return nil if data.blank?
  #   UserKroog.transaction do
  #     unless self.teaser_db_store
  #       self.teaser_db_store = self.build_teaser_db_store
  #       self.teaser_db_store.save
  #     end
  #     self.teaser_db_store.update_attribute(:content, data)
  #   end
  # end
  # 
  # def teaser
  #   return nil unless self.teaser_db_store
  #   return self.teaser_db_store.content
  # end

  # Number of users in this kroogi
  #def user_count
  #  user.followers_count_sum([self.relationshiptype_id])
  #end
    
  # Returns a list of the circle levels that are allowed to see this item (e.g. public item returns all, friends item return friends and closer)
  def levels_can_see
    Relationshiptype.circle_and_closer(relationshiptype_id)
  end  
  
  alias_attribute :circle_id, :relationshiptype_id
  
  # Checks if given user has permission to see the content
  def is_view_permitted?(given_user = nil)
    given_user ||= self.current_actor

    # Guests can't see circles unless they log in
    return false if given_user.guest?
    
    # Oh look, it's me
    return true if given_user.is_self_or_owner?(self.user)
    
    # Fine, let's check the db
    return Relationship.has_follower?(self.user, given_user, self.levels_can_see)
  end

  def this_and_closer_members_count
    [[self] + self.closer_circles].flatten.map{|uk| uk.members_count}.inject(0) {|acc, item| acc + item}    
  end

  #it's not reliable (and even dangerous) to allow easy notification to particularly large circles
  def allow_easy_notifiaction?
    this_and_closer_members_count <= self.user.max_easy_notification_count
  end

  def host_user
    user
  end
  
  def flat_comments?
    false
  end

  Relationshiptype::TYPES.each {|key, value|
    self.class_eval do
      define_method :"#{key}?" do
        self.relationshiptype_id == value
      end
    end
  }

  def friends?
    self.relationshiptype_id == Relationshiptype::TYPES[:backstage]
  end

  def relationshiptype_name
    Relationshiptype::TYPES.detect {|key, value| self.relationshiptype_id == value}.first
  end

  protected
  def set_defaults
    self.teaser = 'Members receive updates on their home page when we post anything new. They are able to see entries that are intended to be seen by this circle and farther.'.t if self.teaser.blank?
    true
  end
end
