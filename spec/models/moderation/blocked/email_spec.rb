require File.dirname(__FILE__) + '/../../../spec_helper'

describe Moderation::Blocked::Email do

  it "should remove weird characters when creating the base email" do
    bad_good = [
      ['kali.donovan@gmail.com', 'kalidonovan@gmail.com'],
      ['kali.donovan+test1@gmail.com', 'kalidonovan@gmail.com'],
      ['.kali.donovan+sneak+scammer@gmail.com', 'kalidonovan@gmail.com'],
    ]
    bad_good.each do |bad, good|
      Moderation::Blocked::Email.base_email( bad ).should == good
    end
  end
  
  it "should automatically strip weird characters when saving the email" do
    email = Moderation::Blocked::Email.new(:email => 'kali.donovan+weird@gmail.com')
    email.email.should == 'kalidonovan@gmail.com'
  end
  
  it "should prevent the creation of new users with blocked email addresses" do
    pending "Spec needs update probably"
    
    Moderation::Blocked::Email.without_monitoring do
      Moderation::Blocked::Email.add('kali.donovan@gmail.com')
    end.should_not raise_error
    
    # DOESN"T SEEM TO BE RUNNING the line in the block above?
    (!!Moderation::Blocked::Email.email_is_blocked?('kalidonovan@gmail.com')).should == true
      
    @user = BasicUser.new({
        :email => 'kali.donovan+123@gmail.com', 
        :password => 'pa33word', :password_confirmation => 'pa33word',
        :login => 'just-a-dumb-test'
      })
    @user.should_not be_valid
    @user.errors.full_messages.should_contain "Sorry, this email has been blocked from the Kroogi Network"
  end
    
  
end
