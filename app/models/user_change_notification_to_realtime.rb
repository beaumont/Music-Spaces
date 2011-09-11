class UserChangeNotificationToRealtime < ActiveRecord::Base
  require 'digest/md5'

  validates_uniqueness_of :user_id

  named_scope :active, {:conditions => {:deleted => false}}
  named_scope :deleted, {:conditions => {:deleted => true}}
  named_scope :by_login, lambda {|query|
    {:conditions => ["login LIKE ?", "%#{query}%"]}
  }

  belongs_to :user

  before_create :generate_token

  private

  def generate_token
    self.token = Digest::MD5.hexdigest("#{self.id} #{self.user_id} #{Time.current}")
  end

end