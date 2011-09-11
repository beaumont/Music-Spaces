require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users, :preferences
  
  def setup
    set_thread
  end

  def test_should_create_user
    assert_difference User, :count do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference User, :count do
      u = create_user(:login => nil)
      assert_errors(u, :match => /^Kroogi name/)
    end
  end

  def test_should_require_password
    assert_no_difference User, :count do
      u = create_user(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference User, :count do
      u = create_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference User, :count do
      u = create_user(:email => '')
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    user = users(:joe)
    user.update_attributes(:old_password => 'password', :password => 'new password', :password_confirmation => 'new password')
    assert_no_errors(user)
    autheduser = User.authenticate('joe', 'new password')
    assert_equal users(:joe), autheduser
  end

  def test_should_not_rehash_password
    users(:joe).update_attributes(:login => 'quentin2')
    assert_equal users(:joe), User.authenticate('quentin2', 'password')
  end

  def test_should_authenticate_user
    assert_equal users(:joe), User.authenticate('joe', 'password')
  end

  def test_should_set_remember_token
    users(:joe).remember_me
    assert_not_nil users(:joe).remember_token
    assert_not_nil users(:joe).remember_token_expires_at
  end

  def test_should_unset_remember_token
    users(:joe).remember_me
    assert_not_nil users(:joe).remember_token
    users(:joe).forget_me
    assert_nil users(:joe).remember_token
  end
  
  def test_should_disallow_duplicate_emails_unless_account_is_deleted
    assert_no_difference User, :count do
      # dup from fixtures
      create_user(:email => 'joe.blow@sonific.com') 
    end
    
    # delete their acount
    User.find_by_email('joe.blow@sonific.com').delete!
    
    # create a new user with the same email 
    assert_difference User, :count do
      assert create_user(:email => 'joe.blow@sonific.com') 
    end
    
  end

  protected
    def create_user(options = {})
      BasicUser.create({ :login => 'quire', :email => 'quire@example.com', :password => 'quire_test', :password_confirmation => 'quire_test', :birthdate => Date.today - 25.year}.merge(options))
    end
    
    def set_thread
      Thread.current['user'] = User.find(:first)
    end
end
