class MonetaryDonation < MonetaryTransaction
  
  include DonationProcessors::Paypal
  include DonationProcessors::Webmoney
  include DonationProcessors::Yandex
  include DonationProcessors::MovableBroker

  belongs_to :invite
  belongs_to :kroogi_circle, :class_name => "UserKroog", :foreign_key => "user_kroog_id"
  belongs_to :sms_payload
  
  belongs_to :karma_point
  
  named_scope :today, {:conditions => ['monetary_transactions.created_at > ?', 1.day.ago]}
  named_scope :donations_received, {:include => [:invite], :conditions => ["user_kroog_id is null and gross_amount_usd >= 0"]}
  named_scope :donations_made, lambda{ |account_owner| {
    :conditions => ['invite_id is null and user_kroog_id is null and sender_account_setting_id = ?', account_owner.id],
    :order => "monetary_transactions.created_at DESC"}
  }

  named_scope :pending, :conditions => ['applied_to_balance = ? and paid = ?', false, false]
  named_scope :applied, :conditions => ['applied_to_balance = ?', true]
  
  before_validation :set_receiver_from_content
  before_create :set_availability
  after_create :process_goodie_ticket

  validates_presence_of :receiver_account_setting_id
  
  def self.total_donations
    sum(:gross_amount_usd) || 0
  end
  
  def display_payment_api
    self.monetary_processor.try(:name)
  end
  
  def recalculate_availability!
    update_attribute(:available_at, created_at + receiver.waiting_period_or_default.days)
  end
  
  # apply to the users balance, also available to be forced
  def apply_to_balance!(forced = false)
    if available_for_balance? || forced
      transaction do
        receiver.increment!(:balance_usd, payable_amount_usd)
        self.update_attribute(:applied_to_balance, true)
      end
    end
  end
  
  def availability_reason
    return 'Unavailable' if new_record?
    return 'No Receiver' if receiver.blank?
    return 'Already Applied' if applied_to_balance?
    return 'Under Investigation' if suspicious?
    return 'Pending Release on ' + self.available_at.to_date.to_s if !waiting_period_exceeded?
  end
  
  def available_for_balance?    
    ![ new_record?,
      paid?,
      receiver.blank?,
      applied_to_balance?,
      !waiting_period_exceeded?,
      suspicious? ].any?
  end
  
  def waiting_period_exceeded?
    return false unless available_at
    available_at < Time.now
  end
    
  def handling_fee_percent
    15.0
  end
  
  def self.sms_charge_percent
    Configuration.sms_charge_percent.blank? ? 10.0 : Configuration.sms_charge_percent
  end
  
  def self.standard_charge_percent
    Configuration.standard_charge_percent.blank? ? 20.0 : Configuration.standard_charge_percent
  end

  def self.sms_charge_percent=(pct)
    Configuration.sms_charge_percent = pct
  end
  
  def self.standard_charge_percent=(pct)
    Configuration.standard_charge_percent = pct
  end
  
  def self.apply_available_donations!
    find(:all, :conditions => ["NOT applied_to_balance AND available_at <= ?", Time.now]).each do |d|
      d.apply_to_balance!
    end
  end

  def anonymous?
    [nil, -1].include?(sender_account_setting_id)
  end
  
  def album_donation?
    self.content.is_a?(BasicFolderWithDownloadables)
  end
  
  def notifiable_donation_received?
    !suspicious? && !album_donation? && !anonymous?
  end
  
  def invitable_as_anonymous_donor?
    anonymous? && !sender_email.blank? && !invite.blank?
  end

  # FIXME: Investigate where this is used and if it is even needed.
  # associates contribution with user_kroog. not used for much other than getting the circle name
  def add_to_kroogi_circle(user_kroog)
    self.kroogi_circle = user_kroog
  end

  protected
  
  def set_receiver_from_content
    #TODO: add error handling here: if receiver is set it shouldn't be different than content's user
    self.receiver = content.user.account_setting if content && content.user
  end
  
  def set_availability
    self.send(:available_at=, Time.now + receiver.waiting_period_or_default.days) if receiver
  end

  def process_goodie_ticket
    return true unless content.is_a?(Tps::GoodieTicket)
    ticket = content
    return true if ticket.succeeded?
    ticket.succeed_with_donation(self)
  end
end
