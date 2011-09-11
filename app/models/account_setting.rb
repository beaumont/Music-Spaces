#  create_table "account_settings", :force => true do |t|
#    t.column "user_id",                         :integer
#    t.column "paypal_email",                    :string,   :limit => 50
#    t.column "donation_title",                  :string
#    t.column "donation_button_label",           :string,   :limit => 70,                                :default => "Donate"
#    t.column "donation_request_explanation",    :text
#    t.column "donation_amount",                 :decimal,                :precision => 10, :scale => 2
#    t.column "show_donation_basket",            :boolean,                                               :default => false
#    t.column "default_language",                :string,                                                :default => "1819"
#    t.column "created_at",                      :datetime
#    t.column "updated_at",                      :datetime
#    t.column "money_status",                    :string
#    t.column "webmoney_wmz",                    :string
#    t.column "webmoney_wme",                    :string
#    t.column "webmoney_wmr",                    :string
#    t.column "allow_sponsorships",              :boolean,                                               :default => false
#    t.column "donation_title_ru",               :string
#    t.column "donation_button_label_ru",        :string
#    t.column "donation_request_explanation_ru", :text
#    t.column "donation_title_fr",               :string
#    t.column "donation_button_label_fr",        :string
#    t.column "donation_request_explanation_fr", :text
#    t.column "notified_of_delay",               :boolean,                                               :default => false
#    t.column "yandex_scid",                     :string
#    t.column "yandex_shopid",                   :string
#    t.column "allow_yandex",                    :boolean,                                               :default => false
#    t.column "paypal_transaction",              :string
#    t.column "webmoney_account",                :string
#    t.column "webmoney_passport_minimum",       :integer,                                               :default => 130
#    t.column "webmoney_account_verified",       :boolean
#    t.column "webmoney_wmz_attached",           :boolean
#    t.column "webmoney_wmr_attached",           :boolean
#    t.column "webmoney_wme_attached",           :boolean
#    t.column "paypal_status",                   :string
#    t.column "paypal_status_last_updated_at",   :datetime
#    t.column "paypal_status_last_updated_by",   :integer
#    t.column "verified_by_kroogi",              :boolean,                                               :default => false
#    t.column "webmoney_attached_at",            :datetime
#    t.column "webmoney_passport_level",         :integer
#    t.column "paypal_user_id",                  :string
#    t.column "paypal_denial_reason",            :string
#    t.column "billable",                        :boolean,                                               :default => false
#    t.column "invoice_agreement_accepted_at",   :datetime
#    t.column "collected_usd",                   :decimal,                :precision => 11, :scale => 2, :default => 0.0
#    t.column "balance_usd",                     :decimal,                :precision => 11, :scale => 2, :default => 0.0
#    t.column "waiting_period",                  :integer
#    t.column "movable_broker_enabled",          :boolean,                                               :default => true,     :null => false
#    t.column "minimum_withdrawal_amount",       :decimal,                :precision => 8,  :scale => 2
#  end
#

# TODO: rename this table to something more fitting
class AccountSetting < ActiveRecord::Base
  #include AASM
  
  xss_terminate :except => [:paypal_status, :paypal_status_last_updated_at, :paypal_status_last_updated_by]
  
  ACCOUNT_TYPES = %w[webmoney_account paypal_email webmoney_wmz webmoney_wme webmoney_wmr yandex_money].freeze
  CURRENCIES = %w(USD)
  
  DEFAULT_NUMBER_OF_WAITING_DAYS = 30
  DEFAULT_MINIMUM_FOR_WITHDRAWAL = 10.00
  
  def self.default_withdrawal_waiting_period
    Configuration[:default_number_of_waiting_days] || DEFAULT_NUMBER_OF_WAITING_DAYS
  end
  
  def self.default_withdrawal_waiting_period=(num)
    Configuration[:default_number_of_waiting_days] = num
  end
  
  def waiting_period_or_default
    (self.waiting_period || AccountSetting.default_withdrawal_waiting_period).to_i
  end
  
  @@real_account_types = (ACCOUNT_TYPES - ["yandex_money", "webmoney_account"]) + ["yandex_scid", "yandex_shopid"]
  cattr_reader :real_account_types
  translates :donation_title, :donation_button_label, :donation_request_explanation, :base_as_default => true
  
  password_required_for(*(ACCOUNT_TYPES - ["yandex_money"]))
  
  acts_as_audited :only => [:paypal_email, :webmoney_account]
  
  belongs_to :user
  belongs_to :project, :class_name => "Project", :foreign_key => "user_id"

  has_one :donation_setting, :as => :accountable, :dependent => :destroy, :validate => false
  include DonationSettingMethods

  attr_accessor :skip_change_notification
  validates_presence_of :donation_button_label
  validates_length_of :donation_button_label, :within => 3..35
  after_save :update_pending_donation_availability
    
  before_validation :cleanup_whitespace_in_accounts, :set_defaults, :remove_donation_button_if_no_accounts
  before_validation :remove_donation_button_if_no_accounts
  after_save :notify_of_account_changes
  
  # Statuses: nil, pending, verified
  named_scope :pending_admin_action, :conditions => 'status like "pending%"'
  named_scope :processing, :conditions => 'status like "processing%"'
  named_scope :verified, :conditions => 'status like "verified%"'
  named_scope :rejected, :conditions => 'status like "rejected%"'
 
  # covers all incoming and outgoing transactions
  has_many :monetary_transactions, :order => "monetary_transactions.created_at DESC", :foreign_key => :receiver_account_setting_id
 
  has_many :donations_made, :class_name => 'MonetaryDonation', :order => "monetary_transactions.created_at DESC", :foreign_key => :sender_account_setting_id
  has_many :donations_received, :class_name => 'MonetaryDonation', :order => "monetary_transactions.created_at DESC", :foreign_key => 'receiver_account_setting_id'

  has_many :monetary_withdrawals, :foreign_key => 'receiver_account_setting_id'
  
  # any accounts which have _ever_ been verified, removed or not.
  has_many :all_monetary_processor_accounts, :class_name => 'MonetaryProcessorAccount'

  # any account which has not been removed in any state
  has_many :monetary_processor_accounts, :conditions => 'deleted_at IS NULL'  
  
  # current does not need to be verified, it may be in the process of being activated
  has_one  :current_monetary_processor_account, :class_name => 'MonetaryProcessorAccount', :conditions => "deleted_at IS NULL"
  
  has_many :karma_points, :through => :user

  def webmoney_account
    monetary_processor_accounts.webmoney.first || WebMoneyAccount.new(:account_setting_id => self.id)
  end

  def paypal_account
    monetary_processor_accounts.paypal.first || PaypalAccount.new(:account_setting_id => self.id)
  end

  def gross_donations_received_since(since=30.days.ago)
    donations_received.sum(:gross_amount_usd, :conditions => ['created_at > ?', since])
  end
  
  def gross_withdrawals_since(since=30.days.ago)
    monetary_withdrawals.sum(:gross_amount_usd, :conditions => ['created_at > ?', since])
  end

  # accessor used to provide minimum amount for withdrawal accepted
  def minimum_for_withdrawal
    (minimum_withdrawal_amount.to_f > 0) ? minimum_withdrawal_amount : DEFAULT_MINIMUM_FOR_WITHDRAWAL
  end
  
  ## End New Modular Money System
  
  (ACCOUNT_TYPES - ["paypal_email", "yandex_money", "webmoney_account"]).each do |atr|
    validates_format_of atr.to_sym, :with => /(^#{atr[-1..-1].upcase}[0-9]{12}$)/, :message => "appears to be invalid", :if => proc{ |as| as.send("#{atr}?") }
  end
 
  # ACCOUNT_TYPES.each do |atr|
  #   validates_confirmation_of atr.to_sym, :if => proc{|acc|  acc.send("#{atr}_changed?") && acc.send("#{atr}?") }
  # end
  
 
 
  acts_as_permitted

  named_scope :notified, :conditions => {:notified_of_delay => true}
  named_scope :not_notified, :conditions => {:notified_of_delay => false}

  # ======================================================
  # = Kroogi Verification States (do we know this user?) =
  # ======================================================
  # Handled by verified_by_kroogi column


  # ================================================================
  # = Donation pilot program (donation requests, acceptance, etc.) =
  # ================================================================
  # aasm_column :money_status
  # aasm_initial_state :money_inactive
  # aasm_state :money_inactive
  # aasm_state :money_requested, :enter => :notify_of_request
  # aasm_state :money_approved,  :enter => :notify_of_approval
  # aasm_state :money_denied
  # 
  # named_scope :with_money_request_any_status, :conditions => 'money_status <> "money_inactive"'
  # named_scope :money_inactive,  :conditions => {:money_status => 'money_inactive'}
  # named_scope :money_pending,   :conditions => {:money_status => 'money_requested'}
  # named_scope :money_approved,  :conditions => [] # Everyone is pre-apprvoved! Call now!
  # named_scope :money_denied,    :conditions => {:money_status => 'money_denied'}  
  
  def initialize(attributes = {})
    super((attributes || {}).reverse_merge(:webmoney_passport_minimum => WebMoneyAccount::DEFAULT_MIN_LEVEL))
  end

  # TODO: remove it
  # Everyone is pre-apprvoved! Call now!
  def money_approved?
    true
  end
  
  # aasm_event :request_donations do
  #   transitions :from => [:money_inactive, :money_denied], :to => :money_requested
  # end
  # 
  # aasm_event :approve_donations do
  #   transitions :from => [:money_requested, :money_denied, :money_inactive], :to => :money_approved
  # end
  #   
  # aasm_event :deny_donations do
  #   transitions :from => [:money_requested, :money_approved, :money_inactive], :to => :money_denied
  # end
  # 
  # aasm_event :money_not_requested do
  #   transitions :from => [:money_requested, :money_approved, :money_denied], :to => :money_inactive
  # end
  
  def notify_of_request
    # UserNotifier.async_deliver_donations_requested(user)
  end

  def notify_of_approval
    # if project 
    #   founders = project.project_founders
    #   founders.each do |f|
    #     UserNotifier.async_deliver_donations_approved(f, project)
    #   end
    # else
    #   UserNotifier.async_deliver_donations_approved(user, nil)
    # end
    # Activity.send_message(self, self.user, :payment_systems_approved)
  end
  
  def invoice_agreement_accepted?
    !invoice_agreement_accepted_at.nil?
  end
  
  def invoice_agreement_accepted!
    self.send(:invoice_agreement_accepted_at=, Time.now)
    self.send(:billable=, true)
    save(false)
  end
  
  # does this account need to accept the billing agreement?
  # The reasons that it would be required...
  # => The invoice agreement has not been accepted yet, and they are not marked as billale.
  def invoice_agreement_required?
    !self.billable? && !self.invoice_agreement_accepted?
  end
    
  # default welcome text gets set if it does not exist
  def donation_request_explanation_with_default
    donation_request_explanation_without_default || Configuration.default_donation_message % owner.display_name
  end
  alias_method_chain :donation_request_explanation, :default
  
  # As long as they once had an approved account set up, they're okay
  def has_an_approved_account_set?
    all_monetary_processor_accounts.was_verified.any?
  end

  # checks requirements to accept donations
  def donatable?
    show_donation_basket? && has_an_approved_account_set? && money_approved?
  end
    
  # wrapper
  def yandex_money
    if yandex_scid && yandex_shopid
      "scid: #{yandex_scid}, ShopId: #{yandex_shopid}"
    end
  end
  
 
 
  # updates the cached existing webmoney activations from the remote host
  def update_existing_webmoney_activations(wm_account)
   transaction do
      # reset them...
      update_attribute('webmoney_wmz_attached', false)
      update_attribute('webmoney_wme_attached', false)
      update_attribute('webmoney_wmr_attached', false)      
      # update them...
      usid = wm_account ? wm_account.account_identifier : WebMoneyAccount.account_identifier(self)
      WebMoney::Ext::Client.get_user_purses_balance(usid).pursesBalances.each do |purse|
        prep = purse.purse.to_i.chr.downcase
        update_attribute("webmoney_wm#{prep}_attached", purse.activated)
        update_attribute("webmoney_attached_at", Time.now)
      end
      update_attribute("webmoney_account_verified", true) if webmoney_any_attached?
   end
  rescue
    false
  end
  
  # When modifying a project, who should get credit for the changes?
  def active_user=(u)
    @active_user = u
  end

  def received(what, sort_by, sort_dir, conditions = {})
    return [] if what.nil?
    sort_by  ||= "created_at"
    sort_dir ||= "DESC"
    delegate_received(what).all(:conditions => conditions,
      :order => "monetary_transactions.#{sort_by} #{sort_dir}")
  end

  def received_total(what, total_kind, column = "created_at", conditions = {})
    delegate_received(what).send(total_kind, column, :conditions => conditions)
  end

  def owner
    @owner ||= (project || user)
  end
  
  def identity_verified?
    has_an_approved_account_set?
  end
  
  def has_karma_points?
    total_karma_points > 0
  end
  
  def total_karma_points
    karma_points.sum(:points)
  end
  
  def karma_points_this_month
    karma_points.this_month.sum(:points)
  end

  def withdrawal_limit?
    withdrawal_limit && !withdrawal_limit.zero?
  end

  def withdrawal_limit_overcome?(amount_to_withdraw)
    return false unless withdrawal_limit?
    total_withdrawn + amount_to_withdraw > withdrawal_limit
  end

  def total_withdrawn
    monetary_withdrawals.paid.sum(:payable_amount_usd)
  end

  def to_withdraw
    return balance_usd unless withdrawal_limit?
    max = [withdrawal_limit - total_withdrawn, 0].max
    [max, balance_usd].min
  end

  protected

  def delegate_received(what)
    if %w(donations_made).include?(what.to_s)
      self.send(what, self.owner)
    elsif %w(donations_received).include?(what.to_s)
      self.send(what)
    elsif %w(monetary_withdrawals).include?(what.to_s)
      self.send(what)
    else
      MonetaryDonation.nothing
    end
  end

  def set_defaults
    self._donation_title = "Please support our project!" if self._donation_title.blank?
    self.donation_title_ru = "Пожалуйста поддержите наш проект!" if self.donation_title_ru.blank?

    self._donation_button_label = "Contribute" if self._donation_button_label.blank?
    self.donation_button_label_ru = "Поблагодарить" if self.donation_button_label_ru.blank?

    self._message_to_donors = "Thank you for your contribution!" if self._message_to_donors.blank?
    self.message_to_donors_ru = "Спасибо за поддержку!" if self.message_to_donors_ru.blank?

    self._donation_request_explanation = "Please support our project!" if self._donation_request_explanation.blank?
    self.donation_request_explanation_ru = "Пожалуйста поддержите наш проект!" if self.donation_request_explanation_ru.blank?
  end

  # Don't show the donation basket if there aren't any accounts to show there
  def remove_donation_button_if_no_accounts
    unless has_an_approved_account_set?
      self.show_donation_basket = false
    end
    true
  end
  
  
  def notify_of_account_changes
    return true if @skip_change_notification
    logger.debug "#[#{self.class.name}] notify_of_account_changes"
    changed_accts = @@real_account_types.select{|acc_type| self.send("#{acc_type}_changed?")}

    # Cycle through changed fields. If was blank, send a account added, else send account changed. Possible to send both, in case model ever gets both types of changes at once.
    if !changed_accts.empty? && self.owner.project?
      is_new_acct = changed_accts.any?{|acc_type| self.send("#{acc_type}_was").blank?}
      is_changed_acct = changed_accts.any?{|acc_type| !self.send("#{acc_type}_was").blank?}
      is_removed_acct = changed_accts.any?{|acc_type| self.send("#{acc_type}").blank?}
      send_account_notification(:donation_account_changed) if is_changed_acct
      send_account_notification(:donation_account_added) if is_new_acct
      send_account_notification(:donation_account_removed) if is_removed_acct
    end
  end

  def send_account_notification(type)
    # User doesn't get notifications (b/c they enter password). Project has notifications sent to all hosts.
    return unless self.project
    
    self.project.founders.each do |founder|
      Activity.send_message(self,self.user, type, {:to_user => founder})
    end
  end
  
  def cleanup_whitespace_in_accounts
    @@real_account_types.each { |acc_type| self[acc_type].strip! if self.respond_to?("#{acc_type}_changed?") && self.send("#{acc_type}_changed?") && self[acc_type] }
  end
  
  def received_donations_sum
    donations_received.sum(:payable_amount_usd)
  end

  def received_donations_pending_sum
    donations_received.pending.sum(:payable_amount_usd)
  end
  
  def update_pending_donation_availability
    if waiting_period_changed?
      self.donations_received.pending.each do |donation|
        donation.recalculate_availability!
      end
    end
  end

end
