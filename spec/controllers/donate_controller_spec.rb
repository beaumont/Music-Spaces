require File.dirname(__FILE__) + '/../spec_helper'

describe DonateController do
  
  describe "changes" do
    it "should be specced" do
      pending 'new specs'
    end
  end
  # include PostBackParamsHelper, AccountSettingSpecHelper
  # 
  # before(:all) do
  #   ch = mock(CashHandler::Base)
  #   ch.stub!(:get).and_return(0.0)
  #   ch.stub!(:convert).and_return(0.0)
  #   CashHandler::Base.stub!(:new).and_return(ch)
  # 
  #   @account_setting = AccountSetting.new({}.merge(webmoney_attributes).merge(yandex_attributes).merge(donation_attributes))
  #   @user = mock_model(User, :display_name => "John Travolta", :id => 1, :login => "bigtimejt", :project? => false)
  #   @preference = mock_model(Preference, :email_locale => nil)
  #   @user.stub!(:preference).and_return(@preference)
  #   @account_setting.stub!(:owner).and_return(@user)
  #   @account_setting.stub!(:user).and_return(@user)
  #   @account_setting.skip_change_notification = true
  #   @account_setting.save
  # end
  # 
  # it "should only allow post requests to postback urls" do
  #   get 'yandex_postback'
  #   response.should_not be_success
  #   
  #   get 'webmoney_postback'
  #   response.should_not be_success
  #   
  #   get 'instant_payment_notification'
  #   response.should_not be_success
  # end
  # 
  # it "should return XML for Yandex Check/Success" do
  #   pending
  #   params = yandex_postback(Time.now, nil, @account_setting)
  #   params[:action] = "Check"
  #   post 'yandex_postback', params
  #   response.headers["type"].should == 'application/xml; charset=windows-1251'
  #   response.should have_tag(%{result[code="0"][action="%s"][shopId="%s"][invoiceId="%s"]} % ["Check", @account_setting.yandex_shopid.to_s, params[:invoiceId]])
  #   #response.body.should == xml_response % ["Check", @account_setting.yandex_shopid.to_s, params[:invoiceId]]
  #   
  #   # make sure it doesn't duplicate it in the second postback
  #   post 'yandex_postback', params
  #   response.headers["type"].should == 'application/xml; charset=windows-1251'
  #   response.should have_tag(%{result[code="0"][action="%s"][shopId="%s"][invoiceId="%s"]} % ["PaymentSuccess", @account_setting.yandex_shopid.to_s, params[:invoiceId]])
  #   #response.body.should == xml_response % ["PaymentSuccess", @account_setting.yandex_shopid.to_s, params[:invoiceId]]
  # end
  # 
  # describe "for general donations" do
  #   it "should handle Yandex request" do
  #     params = yandex_postback(Time.now, nil, @account_setting)
  #     @contrib = MonetaryContribution.from_yandex_params(params)
  #     MonetaryContribution.should_receive(:from_yandex_params).with(params.merge(rails_params("yandex_postback"))).and_return(@contrib)
  #     post 'yandex_postback', params
  #     assigns[:mon_contrib].account_setting.should == @account_setting
  #     response.should be_success
  #   end
  #   
  #   it "should handle Webmoney Pre-request" do
  #     params = webmoney_postback(Time.now, nil, @account_setting)
  #     params[:LMI_PREREQUEST] = "1"
  #     MonetaryContribution.should_not_receive(:from_webmoney_params)
  #     post 'webmoney_postback', params
  #     response.body.should == "YES"
  #   end
  #   
  #   it "should handle regular Webmoney request" do
  #     params = webmoney_postback(Time.now, nil, @account_setting)
  #     @contrib = MonetaryContribution.from_webmoney_params(params)
  #     MonetaryContribution.should_receive(:from_webmoney_params).with(params.merge(rails_params("webmoney_postback"))).and_return(@contrib)
  #     post 'webmoney_postback', params
  #     assigns[:mon_contrib].account_setting.should eql(@account_setting)
  #     response.should be_success
  #   end
  #   
  #   it "should handle PayPal request" do
  #     params = paypal_postback(Time.now, nil, @account_setting)
  #     @contrib = MonetaryContribution.from_paypal_params(params)
  #     MonetaryContribution.should_receive(:from_paypal_params).
  #       with(params.merge(rails_params("instant_payment_notification"))).and_return(@contrib)
  #     post 'instant_payment_notification', params
  #     assigns[:mon_contrib].should == @contrib
  #     response.should be_success
  #   end
  #   
  #   it "should handle paypal masspay activation" do
  #     params = paypal_masspay_ipn_post_params
  #     @contrib = MonetaryContribution.from_paypal_params(params)
  #     MonetaryContribution.should_receive(:from_paypal_params).
  #       with(params.merge(rails_params("instant_payment_notification"))).and_return(@contrib)
  # 
  #     gtd_resp = mock('GtdResponse')
  #     gtd_resp.stub!(:transactionid).and_return('999')
  #     gtd_resp.stub!(:receiveremail).and_return('joe@example.com')
  # 
  #     gtd = mock('Gtd')
  #     gtd.should_receive(:transactionid=).with('999')
  #     gtd.stub!(:response).and_return(gtd_resp)
  # 
  #     Paypal::Request::GetTransactionDetails.should_receive(:new).and_return(gtd)
  #     
  #     pending_account = @account_setting
  #     
  #     proxy = mock('ProxyAssoc')
  #     AccountSetting.stub!(:paypal_processing).and_return(proxy)
  #     proxy.should_receive(:find_all_by_paypal_email).with('joe@example.com').and_return [] #...
  #           
  #     post 'instant_payment_notification', params
  #     
  #     response.should be_success
  #   end
  #   
  #   def paypal_masspay_ipn_post_params
  #     {:txn_type         => 'masspay', 
  #      :payment_status   => 'Processed',
  #      :payment_gross_1  => '0.02',
  #      :sender_email      => 'paypal@kroogi.com',
  #      :status_1         => 'Completed',
  #      :masspay_txn_id_1 => '999'}.stringify_keys
  #   end
  #   
  # end
  # 
  # describe "for donations to content" do
  #   before(:all) do
  #     @content = mock_model(Board, 
  #               :id => 1, 
  #               :title => "save some stuff", 
  #               :show_donation_button => true, 
  #               :donation_button_label => "donate, ya digg?",
  #               :message_to_donors => "hey",
  #               :coupon_expiration_date => 3.days.from_now)
  #     @sender = mock_model(User, :display_name => "El Matador", :id => 2, :login => "elmatador")
  #     @content.stub!(:author).with(@user)
  #   end
  #   
  #   it "should handle Yandex request" do
  #     params = yandex_postback(Time.now, @sender, @account_setting, @content)
  #     @contrib = MonetaryContribution.from_yandex_params(params)
  #     MonetaryContribution.should_receive(:from_yandex_params).with(params.merge(rails_params("yandex_postback"))).and_return(@contrib)
  #     post 'yandex_postback', params
  #     assigns[:mon_contrib].account_setting.should eql(@account_setting)
  #     pending("TODO: fix the spec")
  #     assigns[:mon_contrib].content_id.should   == @content.id
  #     assigns[:mon_contrib].sender_id.should     == @sender.id
  #     response.should be_success
  #   end
  #   
  #   it "should handle regular Webmoney request" do
  #     params = webmoney_postback(Time.now, @sender, @account_setting, @content)
  #     @contrib = MonetaryContribution.from_webmoney_params(params)
  #     MonetaryContribution.should_receive(:from_webmoney_params).with(params.merge(rails_params("webmoney_postback"))).and_return(@contrib)
  #     post 'webmoney_postback', params
  #     assigns[:mon_contrib].account_setting.should eql(@account_setting)
  #     assigns[:mon_contrib].content_id.should   == @content.id
  #     assigns[:mon_contrib].sender_id.should     == @sender.id
  #     response.should be_success
  #   end
  #   
  #   it "should handle PayPal request" do
  #     pending 
  #     
  #     Activity.stub!(:target_user_from_content).and_return(@sender)
  #     
  #     params = paypal_postback(Time.now, @sender, @account_setting, @content)
  #     @contrib = MonetaryContribution.from_paypal_params(params)
  #     MonetaryContribution.should_receive(:from_paypal_params).with(params.merge(rails_params("instant_payment_notification"))).and_return(@contrib)
  #     @contrib.should_receive(:invite_guest_user).and_return(true)
  #     post 'instant_payment_notification', params
  #     assigns[:mon_contrib].account_setting.should eql(@account_setting)
  #     assigns[:mon_contrib].content_id.should     == @content.id
  #     assigns[:mon_contrib].sender_id.should       == @sender.id
  #     response.should be_success
  #   end
  # end
  # 
  # it "should not break on IPN calls with unknown transactions" do
  #   post :instant_payment_notification, "tax"=>"0.00", "payment_status"=>"Completed", "address_name"=>"Alex Petrov",
  #        "address_city"=>"St. Petersburg", "receiver_email"=>"paypal@kroogi.com", "address_zip"=>"191119",
  #        "business"=>"paypal@kroogi.com", "address_country"=>"Russia", "quantity"=>"0",
  #        "receiver_id"=>"NT5RB7BYZH3ZG", "transaction_subject"=>"Kroogi", "payment_gross"=>"0.02",
  #        "action"=>"instant_payment_notification", "notify_version"=>"2.8", "payment_fee"=>"0.02",
  #        "mc_currency"=>"USD", "address_street"=>"some address", "address_country_code"=>"RU",
  #        "verify_sign"=>"AQU0e5vuZCvSg-XJploSa.sGUDlpAyi9GPSVoL27.xZwXISq7rh-fSL1", "txn_id"=>"15C71865B2795090B",
  #        "item_name"=>"Kroogi", "txn_type"=>"web_accept", "mc_gross"=>"0.02", "address_status"=>"unconfirmed",
  #        "sender_id"=>"3QKPUVTNR5CJJ", "charset"=>"windows-1252", "mc_fee"=>"0.02", "last_name"=>"Petrov",
  #        "controller"=>"donate", "custom"=>"", "sender_status"=>"verified", "address_state"=>"",
  #        "protection_eligibility"=>"PartiallyEligible", "payment_date"=>"04:44:16 Jul 12, 2009 PDT",
  #        "sender_email"=>"omg@mail.ru", "residence_country"=>"RU", "first_name"=>"Alex", "payment_type"=>"instant",
  #        "item_number"=>""
  # end
  # 
  # protected
  # def rails_params(action)
  #   {
  #     "action"=> action,
  #     "controller" => "donate"
  #   }
  # end
  # 
  # def xml_response
  #   %{
  #     <?xml version="1.0" encoding="windows-1251"?>
  #     <response performedDatetime="#{Time.now.xmlschema}">
  #       <result code="0" action="%s" shopId="%s" invoiceId="%s"/>
  #     </response>
  #   }.strip
  # end  
end
