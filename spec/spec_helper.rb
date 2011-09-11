# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'
require File.dirname(__FILE__) + '/../test/test_utils_mixin'
require 'lib/authenticated_test_helper'
require 'lib/random_string'

# custom helpers
module CurrentUser
  def with_current_user(user, &block)
    Thread.current['user'] = user
    result = block.call
    Thread.current['user'] = nil
    result
  end  
end

module AccountSettingSpecHelper
  
  def donation_attributes
    {
      :donation_request_explanation => "I need stuff",
      :donation_title => "Make a donation please"
    }
  end
  
  def webmoney_attributes
    {
      :webmoney_wmz => "Z000000000000",
      :webmoney_wme => "E000000000000",
      :webmoney_wmr => "R000000000000"
    }
  end
  
  def yandex_attributes
    {
      :yandex_scid => "12345",
      :yandex_shopid => "123456789"
    }
  end
end

module PostBackParamsHelper
  def yandex_postback(date = Time.now, sender = nil, account = nil, content = nil)
    p,acc,c = [sender, account, content].collect{|i| i.id if i}
    
    {
     "scid"=>"1643",
     "shopSumAmount"=>"20.00",
     "orderSumBankPaycash"=>"1001",
     "shopSumBankPaycash"=>"1001",
     "orderCreatedDatetime"=>"2005-01-21T10:20:04Z",
     "requestDatetime"=>"2005-01-21T10:20:10Z",
     "paymentType"=>"1",
     "orderIsPaid"=>"1",
     "action"=>"PaymentSuccess",
     "paymentDatetime"=>"2005-01-21T10:20:10Z",
     "orderSumCurrencyPaycash"=>"643",
     "MyField"=> CGI::escape("#{acc};#{c};#{p}"),
     "customerNumber"=>"8123294469",
     "invoiceId"=>RandomString.generate(7),
     "md5"=> Digest::MD5.hexdigest(RandomString.generate(5)),
     "paymentPayerCode"=>"42007148320",
     "shopSumCurrencyPaycash"=>"643",
     "orderSumAmount"=>"20.00",
     "shopId"=>"13"
     }.with_indifferent_access
  end
  
  def paypal_postback(date = Time.now, sender = nil, account = nil, content = nil, new_format = false)
    p,acc,c = [sender, account, content].collect{|i| (new_format ? i.id : LegacyIdHash.id_to_hash(i.id)) if i}
    {"tax"=>"0.00",
     "payment_status"=>"Completed",
     "address_name"=>"Miroslav Sarbaev",
     "business"=>"miro@your-net-works.com",
     "address_country"=>"United States",
     "address_city"=>"San Francisco",
     "sender_email"=>"miro@gnsi-inc.com",
     "receiver_id"=>"8XJ4L98QTYEX2",
     "residence_country"=>"US",
     # default $20
     "payment_gross"=>"20.00",
     "merchant_return_link"=>"Return to Kroogi",
     "receiver_email"=>"miro@your-net-works.com",
     "address_street"=>"1351 McAllister Street",
     "verify_sign"=>"An5ns1Kso7MWUdW4ErQKJJJ4qi4-A3oTGgEDCqpqeaux0vyzuMcqddx9",
     "action"=>"thank_you",
     "address_zip"=>"94115",
     "quantity"=>"0",
     "txn_type"=>"web_accept",
     "mc_currency"=>"USD",
     "charset"=>"windows-1252",
     "address_country_code"=>"US",
     "txn_id"=> RandomString.generate(17),
     "item_name"=> c.try(:title, "Testing PayPal transactions"),
     "controller"=>"donate",
     "notify_version"=>"2.4",
     "address_state"=>"CA",
     "address_status"=>"confirmed",
     "payment_date"=> date.to_s,
     "sender_status"=>"verified",
     "first_name"=>"Miroslav",
     "payment_type"=>"instant",
     "mc_gross"=>"20.00",
     "payment_fee" => "1.00",
     "sender_id"=>"W8N9N3RDY8C8C",
     "last_name"=>"Sarbaev",
     "custom"=> CGI::escape("#{acc};#{c};#{p}"),
     "item_number"=>""
     }.with_indifferent_access
  end
  
  # 2 cent activation postback
  #{"tax"=>"0.00", "payment_status"=>"Completed", "address_name"=>"Josh Martin", "address_city"=>"Spokane", "receiver_email"=>"paypal-staging@kroogi.com", "address_zip"=>"99208", "business"=>"paypal-staging@kroogi.com", "address_country"=>"United States", "quantity"=>"0", "receiver_id"=>"2NHKFKSQEQKFN", "transaction_subject"=>"Kroogi Staging Donation", "payment_gross"=>"0.02", "action"=>"instant_payment_notification", "notify_version"=>"2.8", "payment_fee"=>"0.02", "mc_currency"=>"USD", "address_street"=>"5318 W. Woodside", "address_country_code"=>"US", "verify_sign"=>"AUaxvSojqajxsiGA9qXfGuCulUctA9DkvZstbhPU5U2-Bb-94cfdioIj", "txn_id"=>"1AH58030JT523021X", "item_name"=>"Kroogi Staging Donation", "txn_type"=>"web_accept", "mc_gross"=>"0.02", "address_status"=>"confirmed", "payer_id"=>"3Y4DU6WXAM3HY", "charset"=>"windows-1252", "mc_fee"=>"0.02", "last_name"=>"Martin", "controller"=>"monetary_processors/paypal", "custom"=>"", "payer_status"=>"verified", "address_state"=>"WA", "protection_eligibility"=>"Eligible", "payment_date"=>"11:04:00 Sep 05, 2009 PDT", "payer_email"=>"jmartin@webwideconsulting.com", "residence_country"=>"US", "first_name"=>"Josh", "payment_type"=>"instant", "item_number"=>""}
  def paypal_postback_activation(date = Time.now)
    {"tax"=>"0.00",
     "payment_status"=>"Completed",
     "address_name"=>"Josh Martin",
     "address_city"=>"Spokane",
     "receiver_email"=>"paypal@kroogi.com",
     "address_zip"=>"99208",
     "business"=>"paypal@kroogi.com",
     "address_country"=>"United States",
     "quantity"=>"0",
     "receiver_id"=>"2NHKFKSQEQKFN",
     "transaction_subject"=>"Kroogi Staging Donation",
     "payment_gross"=>"0.02",
     "action"=>"instant_payment_notification",
     "notify_version"=>"2.8",
     "payment_fee"=>"0.02",
     "mc_currency"=>"USD",
     "address_street"=>"5318 W. Woodside",
     "address_country_code"=>"US",
     "verify_sign"=>"AUaxvSojqajxsiGA9qXfGuCulUctA9DkvZstbhPU5U2-Bb-94cfdioIj",
     "txn_id"=> RandomString.generate(17),
     "item_name"=>"Kroogi Staging Donation",
     "txn_type"=>"web_accept",
     "mc_gross"=>"0.02",
     "address_status"=>"confirmed",
     "payer_id"=>"3Y4DU6WXAM3HY",
     "charset"=>"windows-1252",
     "mc_fee"=>"0.02",
     "last_name"=>"Martin",
     "controller"=>"monetary_processors/paypal",
     "custom"=> "",
     "payer_status"=>"verified",
     "address_state"=>"WA",
     "protection_eligibility"=>"Eligible",
     "payment_date"=> date.to_s,
     "payer_email"=>"jmartin@webwideconsulting.com",
     "residence_country"=>"US",
     "first_name"=>"Josh",
     "payment_type"=>"instant",
     "item_number"=>""}.with_indifferent_access
  end
  
  # ?item_id=&LMI_SYS_TRANS_NO=750&user_acc=NTRdW2SjpvCy2LD11dK7p3v%252BTejsQWcJ7ajRFs0VsYAOPpmE&action=webmoney_postback&item_name=&controller=donate&LMI_SYS_TRANS_DATE=20080603%2002:49:53&LMI_PAYMENT_NO=0&LMI_SYS_INVS_NO=156&custom=NjBdW7vippVeMHLQCbG572yVd3IT0o4FouJCzL1EHwIjc15U"
  def webmoney_postback(date = Time.now, sender = nil, account = nil, content = nil, new_format = false)
    p,acc,c = [sender, account, content].collect{|i| (new_format ? i.id : LegacyIdHash.id_to_hash(i.id)) if i}
    {"ann_id"=>CGI::escape(c || ""),
     "LMI_PAYER_WM"=>"829497056529",
     "LMI_PAYER_PURSE"=>"R337079810231",
     "LMI_SYS_TRANS_NO"=>"111419016",
     "user_acc"=> CGI::escape(acc),
     "action"=>"webmoney_postback",
     "item_name"=> c.try(:title,"Testing WM transactions"),
     "controller"=>"donate",
     "LMI_SYS_TRANS_DATE"=> date.to_s,
     "LMI_MODE"=>"0",
     "LMI_PAYMENT_AMOUNT"=>"20.00",
     "LMI_HASH"=> RandomString.generate(64),
     "LMI_PAYEE_PURSE"=>"R168785036409",
     "LMI_PAYMENT_NO"=>"0",
     "LMI_SYS_INVS_NO"=>"52080318",
     "p_id"=> CGI::escape(p || "")
    }.with_indifferent_access
  end
end

module ProfileSpecHelper
  
  def random_string(len = 10)
     #generate a random password consisting of strings and digits
     chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
     newpass = ""
     1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
     return newpass
  end
  
  def create_param(att, answer, show_on_kroogi_page)
    { att => {"answer" => answer, "show_on_kroogi_page" => show_on_kroogi_page}}
  end
  
  def profile_params
    {"skype"=>{"show_on_kroogi_page"=>"1", "answer"=>"skype"},
     "occupation"=>{"answer"=>"my occupation"},
     "city"=>{"answer"=>"joliet"},
     "question_list"=>
      [{"answer"=>"a1",  "question"=>"q1"},
       {"answer"=>"a2",  "question"=>"q2"},
       {"answer"=>"this is question num 3", "question"=>"question 3"},
       {"answer"=>"a4", "question"=>"q4"}],
     "birthdate"=>{"show_on_kroogi_page"=>"1", "answer"=>"2008-05-26"},
     "yahoo"=>{"show_on_kroogi_page"=>"1", "answer"=>"yahoo"},
     "country"=>{"answer"=>"country"},
     "website"=>{"show_on_kroogi_page"=>"1", "answer"=>"http://internet.com"},
     "myspace"=>{"show_on_kroogi_page"=>"1", "answer"=>"myspace"},
     "msn"=>{"show_on_kroogi_page"=>"1", "answer"=>"msn"},
     "gmail"=>{"show_on_kroogi_page"=>"1", "answer"=>"gmail"},
     "lj"=>{"show_on_kroogi_page"=>"1", "answer"=>"lj"},
     "aol"=>{"show_on_kroogi_page"=>"1", "answer"=>"aol"},
     "bio"=>{"show_on_kroogi_page"=>"1", "answer"=>"about us"},
     "school"=>{"show_on_kroogi_page"=>"1", "answer"=>"school"},
     "interests"=>{"show_on_kroogi_page"=>"1", "answer"=>"interests"}}
  end
  
  def empty_params
    {"skype"=>{"show_on_kroogi_page"=>"0", "answer"=>""},
     "occupation"=>{"answer"=>""},
     "city"=>{"answer"=>""},
     "birthdate"=>{"show_on_kroogi_page"=>"0", "answer"=>""},
     "yahoo"=>{"show_on_kroogi_page"=>"0", "answer"=>""},
     "country"=>{"answer"=>""},
     "website"=>{"show_on_kroogi_page"=>"0", "answer"=>""},
     "myspace"=>{"show_on_kroogi_page"=>"0", "answer"=>""},
     "msn"=>{"show_on_kroogi_page"=>"0", "answer"=>""},
     "gmail"=>{"show_on_kroogi_page"=>"0", "answer"=>""},
     "lj"=>{"show_on_kroogi_page"=>"0", "answer"=>""},
     "aol"=>{"show_on_kroogi_page"=>"0", "answer"=>""},
     "bio"=>{"show_on_kroogi_page"=>"0", "answer"=>""},
     "school"=>{"show_on_kroogi_page"=>"0", "answer"=>""},
     "interests"=>{"show_on_kroogi_page"=>"0", "answer"=>""}}.with_indifferent_access
    
  end
end

module UserSpecHelper
  def user_attributes
    {
      :login => "genericguy",
      :display_name => "My Name",
      :password => "password",
      :password_confirmation => "password",
      :email => "test@test.com",
      :state => "active"
    }
  end
  
  def user_mock_attributes(uid = nil)
    user_attributes.merge({
      :project? => false,
      :id => (uid || 10)
    })
  end
end

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/test/fixtures/'
  config.include CurrentUser
  
  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  config.global_fixtures = :all #:globalize_languages, :globalize_countries

  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end
include TestUtilsMixin
include AuthenticatedTestHelper

module SpecHelpersMixin
  def set_current_user(user_symbol, options = {})
    @current_user = users(user_symbol)
    controller.stub!(:current_user).and_return(@current_user)
    if options[:actor]
      @current_user.update_attribute(:on_behalf_id, options[:actor].id)
    end
    @current_user
  end

  def use_new_caching_keys
    ENV["RAILS_APP_VERSION"] = RandomString.generate(5)    
  end
end