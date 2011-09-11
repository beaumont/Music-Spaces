class PasswordReset < ActiveRecord::Base
  belongs_to :user
  before_save :encrypt_password
  attr_accessor :password

  def encrypt_password
    return if password.blank?
    self.crypted_password = encrypt(password)
  end

  def randomize_password!
    self.password = random_alphanum_string(6)
    return self.password
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  private
  include StringUtilsMixin

  def encrypt(password)
    User.encrypt(password, user.salt)
  end
  
end