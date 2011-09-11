#
#  create_table "monetary_transactions", :force => true do |t|
#    t.column "receiver_account_setting_id",   :integer
#    t.column "sender_account_setting_id",     :integer
#    t.column "content_id",                    :integer
#    t.column "monetary_processor_account_id", :integer
#    t.column "currency_id",                   :integer
#    t.column "monetary_processor_id",         :integer
#    t.column "monetary_processor_log",        :text
#    t.column "gross_amount",                  :decimal,  :precision => 11, :scale => 2, :default => 0.0
#    t.column "gross_amount_usd",              :decimal,  :precision => 11, :scale => 2, :default => 0.0
#    t.column "monetary_processor_fee_usd",    :decimal,  :precision => 11, :scale => 2, :default => 0.0
#    t.column "net_amount_usd",                :decimal,  :precision => 11, :scale => 2, :default => 0.0
#    t.column "payable_amount_usd",            :decimal,  :precision => 11, :scale => 2, :default => 0.0
#    t.column "handling_fee_usd",              :decimal,  :precision => 11, :scale => 2, :default => 0.0
#    t.column "applied_to_balance",            :boolean,                                 :default => false
#    t.column "suspicious",                    :boolean,                                 :default => false
#    t.column "paid",                          :boolean,                                 :default => false
#    t.column "type",                          :string
#    t.column "available_at",                  :datetime
#    t.column "created_at",                    :datetime
#    t.column "updated_at",                    :datetime
#    t.column "invite_id",                     :integer
#    t.column "sms_payload_id",                :integer
#    t.column "conversion_rate",               :decimal,  :precision => 11, :scale => 6
#    t.column "sender_email",                  :string
#    t.column "item_name",                     :string
#    t.column "params",                        :text
#    t.column "user_kroog_id",                 :integer
#    t.column "token",                         :string
#    t.column "billable",                      :boolean,                                 :default => false
#    t.column "state",                         :string
#    t.column "karma_point_id",                :integer
#  end
#
class MonetaryTransaction < ActiveRecord::Base
  
  serialize :params
  #xss_terminate :except => [:monetary_processor_log, :params]

  CURRENCY_TABLE = {
    'usd' => 1,
    'rur' => 2,
    'eur' => 3
  }.freeze  
  
  validates_numericality_of :gross_amount, :greater_than_or_equal_to => 0
  validates_inclusion_of :currency_id, :in => CURRENCY_TABLE.values

  belongs_to :receiver, :class_name => 'AccountSetting', :foreign_key => :receiver_account_setting_id
  belongs_to :sender, :class_name => 'AccountSetting', :foreign_key => :sender_account_setting_id
  belongs_to :content, :polymorphic => true
  belongs_to :monetary_processor
  before_validation_on_create :convert_currency
  after_validation :calculate_amounts
  after_validation :set_default_content_type

  attr_accessor :monetary_processor_fee

  def currency
    CURRENCY_TABLE.invert[self.currency_id].try(:upcase)
  end
  
  def currency=(name)
    return if name.nil?
    self.send(:currency_id=, CURRENCY_TABLE[name.downcase])
  end
  
  # override this method as needed to calculate handling fee
  def handling_fee_percent
    0
  end
  
  def suspect!
    update_attribute(:suspicious, true)
  end

  def processor_name
    return nil unless monetary_processor
    monetary_processor.name
  end
  
  def availability_reason
    ''
  end
  
  protected
  
  # Converts foreign currencies in to usd
  def convert_currency
    ch = CashHandler::Base.instance
    cur = self.currency
    cur = 'USD' if cur.blank?
    self.send(:conversion_rate=,  ch.get('USD', :against => cur))
    self.send(:gross_amount_usd=, ch.convert(self.gross_amount, cur, 'USD'))
    self.send(:monetary_processor_fee_usd=, ch.convert(self.monetary_processor_fee, cur, 'USD'))
  rescue Exception => e
    AdminNotifier.async_deliver_alert("Error converting currency to USD: #{e.inspect}")
    self.send(:suspect!)
    self.send(:conversion_rate=, 1.0)
    self.send(:gross_amount_usd=, 0.0)
  end

  def calculate_amounts
    self.send(:billable=,           self.receiver.billable?) if self.receiver
    self.send(:net_amount_usd=,     (self.gross_amount_usd || 0) - (self.monetary_processor_fee_usd ||0))
    self.send(:handling_fee_usd=,   self.net_amount_usd * (self.handling_fee_percent || 0) / 100.0) if self.billable?
    self.send(:payable_amount_usd=, self.net_amount_usd - (self.handling_fee_usd || 0))
  end
  
  def set_default_content_type
    self.content_type = 'Content' if self.content_id && !self.content_type
    true
  end

end
