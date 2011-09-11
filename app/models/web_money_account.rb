#  create_table "monetary_processor_accounts", :force => true do |t|
#    t.column "account_setting_id",    :integer
#    t.column "monetary_processor_id", :integer
#    t.column "account_identifier",    :string
#    t.column "account_type",          :string
#    t.column "verified_at",           :datetime
#    t.column "created_at",            :datetime
#    t.column "updated_at",            :datetime
#    t.column "deleted_at",            :datetime
#    t.column "type",                  :string
#    t.column "external_id",           :string
#    t.column "account_level",         :integer
#    t.column "state",                 :string
#    t.column "reason",                :string
#    t.column "created_by_id",         :integer
#    t.column "updated_by_id",         :integer
#  end
#
class WebMoneyAccount < MonetaryProcessorAccount
  include AASM

  DEFAULT_MIN_LEVEL = 120
  DEFAULT_WITHDRAWAL_LIMIT_FOR_DEFAULT_LEVEL = 200

  WM_ACCOUNT_TYPES = [
    ['Any Passport',         0],
    ['Anonymous Passport', 100],
    ['Initial Passport', 120],
    ['Personal Passport',  130],
    ['Merchant Passport',  135],
  ].freeze

  WM_PURSE_TYPES = {
    :webmoney_wmz => 'US Dollars (Z)',
    :webmoney_wmr => 'Russian Rubles (R)',
    :webmoney_wme => 'European Euros (E)'
  }.freeze

  before_save :set_account_identifier

  def self.account_identifier(account_setting)
    if account_setting.is_a?(AccountSetting)
      account_setting = unless account_setting.user.login == Kroogi::KROOGI_ACCOUNT
        account_setting.id
      else
        Kroogi::KROOGI_ACCOUNT
      end
    end
    Kroogi.environmental(account_setting.to_s, :separator => '_') #url-safe separator to avoid md5 sign issues
  end
  
  def self.level_id_to_name
    Hash[*WebMoneyAccount::WM_ACCOUNT_TYPES.flatten].invert
  end
                                        
  # TODO: Fix this, should be from account_setting as a default
  def self.minimum_level_required
    level_id_to_name[DEFAULT_MIN_LEVEL]
  end

  def minimum_level_required
    min = account_setting.webmoney_passport_minimum
    self.class.level_id_to_name[min] || self.class.minimum_level_required
  end
  
  # passport level must be >= to webmoney_passport_minumum
  def is_permitted_to_receive_wm?
    begin
      user_info = WebMoney::Ext::Client.get_user_info(self.account_identifier).userInfo
      passport_level = user_info.passportType
      raise("Webmoney returned empty passport_level for account_setting_id #{self.account_setting.id}. " +
              "This means their passport service is down or their web service got broken") if passport_level.blank?
      passport_level = passport_level.to_i
    rescue => e # WM side error
      raise WebMoney::Errors::ConversationError.new(e)
    end
    result = false
    self.class.transaction do
      update_attributes!(:account_level => passport_level, :external_id => "WMID #{user_info.wMID}")
      return false if passport_level < account_setting.webmoney_passport_minimum
      if !account_setting.withdrawal_limit && passport_level <= WebMoneyAccount::DEFAULT_MIN_LEVEL
        account_setting.update_attributes!(:withdrawal_limit => DEFAULT_WITHDRAWAL_LIMIT_FOR_DEFAULT_LEVEL)
        
      elsif passport_level > WebMoneyAccount::DEFAULT_MIN_LEVEL && account_setting.withdrawal_limit == DEFAULT_WITHDRAWAL_LIMIT_FOR_DEFAULT_LEVEL
        account_setting.update_attributes!(:withdrawal_limit => nil)
      end
    end
    true
  end

  def display_subtype
    'WebMoney - %s' % account_type
  end

  def display_level
    self.class.level_id_to_name[account_level] || "Unknown Account"
  end
  
  # withdrawals are created directly from Monetary
  def process_withdrawal(withdrawal)
    transfer = WebMoneyTransfer.create(
      :receiver_account_setting_id => withdrawal.receiver_account_setting_id,
      :sender_account_setting_id => Kroogi::KROOGI_ACCOUNT,
      :purse_type => WebMoney::Ext::Client::USD,
      :amount => withdrawal.gross_amount_usd)

    params = [self.class.account_identifier(Kroogi::KROOGI_ACCOUNT), 
      self.account_identifier,
      transfer.request_number,
      WebMoney::Ext::Client::USD,
      withdrawal.gross_amount_usd.to_f,
      Kroogi.environmental("Withdrawal to #{withdrawal.receiver.user.login}", :separator => ' env : ')] #WM sign hash check breaks with localized string, so not translating
    res = WebMoney::Ext::Client.send_funds(*params)
      
    if res.errordesc == 'Success'
      transfer.update_attribute(:success, true)
    else
      suffix = "WM said: '#{res.errordesc}', result code #{res.sendFundsResult}. Tried params were #{params.inspect}."
      transfer.update_attributes(:success => false, :response => res.instance_variables.map {|var| [var[1..-1], res.instance_variable_get(var)]}.to_hash)
      if res.errordesc['Object reference not set']
        #WM can tranfer money from us in this case, and still return an error - we had exactly this with pur:pur
        raise Kroogi::Money::ProcessorInternalError.new(
                "WebMoney had internal error that could prevent the transfer to succeed. Please contact us if the transfer doesn't happen in next 10 minutes.".t,
                suffix)
      end
      raise Kroogi::Money::WithdrawalFailed.new(suffix)
    end
  end

  def payment_system_type_label
    'Webmoney'
  end

  protected
  
  # Remove the users purses
  def when_removed
    WebMoney::Ext::Client.get_user_purses_balance(self.account_identifier).pursesBalances.each do |purse|
      WebMoney::Ext::Client.remove_purse(self.account_identifier, purse.purse.to_i)
    end
  end

  def set_account_identifier
    self.account_identifier ||= self.class.account_identifier(self.account_setting)
  end

end
