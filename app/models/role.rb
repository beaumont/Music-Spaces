# == Schema Information
# Schema version: 20081224151519
#
# Table name: roles
#
#  id     :integer(11)     not null, primary key
#  name   :string(30)      not null
#  status :integer(4)      default(1), not null
#

class Role < ActiveRecord::Base
  
  # --------------------------
  # Validators
  # --------------------------  
  

  validates_uniqueness_of :name
  validates_length_of :name, :within => 3..30
  has_and_belongs_to_many :users

  # --------------------------
  # Static vars and getters/setters
  # --------------------------
  
  # role ids enum
  ANON, ADMIN, USER, MODERATOR = 1, 2, 3, 4
  
  # --------------------------
  # Public Methods
  # --------------------------
  
  def status_name
    Status::STATUS_NAMES[self.status]
  end
  
  def active?
    self.status == Status::ACTIVE
  end

  def self.admin
    self.find(ADMIN)
  end

  # --------------------------
  # Protected Methods
  # --------------------------
  protected

  # framework callback
  def before_create
    self.name = self.name.downcase unless self.name.blank?
  end

  # framework callback
  def before_update 
    self.name = self.name.downcase unless self.name.blank?
  end
  
  
end
