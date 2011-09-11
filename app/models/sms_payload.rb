# == Schema Information
# Schema version: 20081006211752
#
# Table name: sms_payloads
#
#  id                    :integer(11)     not null, primary key
#  from_user_id          :integer(11)
#  to_account_setting_id :integer(11)
#  payment_for_id        :integer(11)
#  payment_for_type      :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  postback_received_at  :datetime
#  cloned_from_id        :integer(11)
#

class SmsPayload < ActiveRecord::Base
  # raise the right exception, not an anonymous runtime error
  class InvalidChecksum < RuntimeError
    attr_accessor :message
    def initialize(our_hash,cs,url)
      @message = %{
                    \nOur hash: (#{our_hash})
                    \nSent hash: (#{cs})
                    \nRaw request: #{url}
                  }
    end
  end
  
  # Invite when joining, UserKroog when joining with no invite, Content when donating to content, nil when just donation to user
  ACCEPT_PAYMENTS_FOR = ['Invite', 'Content', 'UserKroog']
  POSTBACK_RESPONSE_URL = URI.parse("http://smszamok.ru/client/iface-all.php?id=20570").freeze
  SMS_SECRET = 'opt1mus_prim3'.freeze # DO NOT CHANGE THIS
  SMS_MEMBER_NUMBER = if RAILS_ENV == 'production' then '20570'
  elsif RAILS_ENV == 'staging' then '20823'
  elsif RAILS_ENV == 'development' then 'NUM_HERE_IN_PROD'
  else nil
  end

  belongs_to :from_user, :class_name => 'User'
  belongs_to :to_account_setting, :class_name => 'AccountSetting'
  belongs_to :payment_for, :polymorphic => true
  has_one :monetary_donation
  
  # If cloning is necessary, track the original
  belongs_to :cloned_from, :class_name => 'SmsPayload'

  validates_presence_of :to_account_setting

  def self.nice_dump
    results = [['ID', 'Payload', 'Payment From', 'Payment To', 'Payment for']]
    SmsPayload.find(:all).each{|x| results << [x.id, x.payload, x.from_user ? x.from_user.login : 'Guest User', x.to_user.login, x.payment_for ? "#{x.payment_for.class.name} #{x.payment_for.id}#{' ('+x.payment_for.title_long+')' if x.payment_for.respond_to?(:title_long)}" : ''].join("\t")}
    puts results.join("\n")
  end

  def to_user
    to_account_setting.user
  end

  def payload
    SmsPayload.id_to_payload(self.id)
  end

  # If first postback received, mark it. Otherwise, clone and mark.
  def handle_postback
    # If this postback has already been paid
    if self.postback_received_at
      clone = SmsPayload.create(:from_user_id => from_user_id, :to_account_setting_id => to_account_setting_id, :cloned_from_id => self.id,
                    :payment_for_type => payment_for_type, :payment_for_id => payment_for_id, :postback_received_at => Time.now)
      return clone
    end
    
    update_attribute(:postback_received_at, Time.now)
    return self
  end

  # Payment Type 1 (commercial projects)  -- applies for most of the projects  M = 2.5%; K= 2.5%
  # Payment Type 2 (special projects)  -- applies to Akvarium and special projects  M = 2.5%; K= 0%
  # Payment Type 3 (charitable projects)  -- applies for most of the projects  M = 0.5%; K= 0%
  def self.calculate_payment_from_received_cost(c, type = 2)
    amt = c.is_a?(Float) ? c : c.to_f
    case type
    when 1 then amt = (amt * 0.95)    # Subtract 2.5% for M and K
    when 2 then amt = (amt * 0.975)   # Subtract 2.5% for M
    when 3 then amt = (amt * 0.995)   # Subtract 0.5% for M
    end
    return ("%.02f" % amt).to_f
  end
  
  def self.calculate(from, to, payment_for = nil)
    to = to.account_setting if to.is_a?(User)
    opts = {
      :from_user_id => from.id,
      :to_account_setting_id => to.id,
      :payment_for_type => payment_for ? payment_for.class.to_s : nil, 
      :payment_for_id => payment_for ? payment_for.id : nil
    }
    
    p = SmsPayload.find(:first, :conditions => opts) || SmsPayload.create(opts)
    return SmsPayload.id_to_payload(p.id)
  end
  
  # Find a record based on the payload
  def self.retrieve(payload)
    id = SmsPayload.payload_to_id(payload)
    id ? SmsPayload.find_by_id( id ) : nil
  end
  
  # Base36 (can't go higher, b/c want case insensitive) encoding of id (for user to text)
  # Base 26 of id, shifted to a-z (no numbers), plus an alphabetical character (that grows z-to-a, not a-to-z)
  def self.id_to_payload(id)
    return id.to_s
    base = ''
    id.to_s(26).each_char do |x|
      base += (x.to_i(26) + 10).to_s(36)
    end
    crc = ((26 - (id % 26))+9).to_s(36)
    "#{base}#{crc}"
  end

  # Return nil unless the CRC matches
  def self.payload_to_id(payload)
    ipayload = payload.to_i
    return ipayload if ipayload > 0 
    crc = payload.last
    payload = payload[0,payload.size-1]
    return nil unless payload
    
    base = ''
    payload.each_char do |x|
      temp = (x.to_i(36) - 10)
      return nil if temp < 0
      base += temp.to_s(26)
    end
    base = base.to_i(26)
    
    expected_crc = ((26 - (base % 26))+9).to_s(36)
    expected_crc == crc ? base : nil
  end

  
  # Accept the sms payment as a donation to the user, regardless of what it was originally intended for
  # (useful if payment is too little, or already in closer circle, or invite is no longer current... etc)
  def accept_as_normal_donation
    update_attributes(:payment_for_type => nil, :payment_for_id => nil)
    return nil # so you can do thing = sms.accept_as_normal_donation and have updated sms.payment_for in thing
  end
  
  # Does the payment have to equal a certain threshhold?
  def required_cost
    return nil unless payment_for && (payment_for.is_a?(Invite) || payment_for.is_a?(UserKroog))
    return payment_for.amount_usd.to_f
  end
  
end
