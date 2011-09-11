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
class MonetaryProcessorAccount < ActiveRecord::Base
  include AASM
 
  belongs_to :account_setting
  validates_presence_of :account_setting_id
  belongs_to :monetary_processor
  validates_presence_of :monetary_processor_id

  delegate :short_name, :to => :monetary_processor
  delegate :user,  :to => :account_setting

  named_scope :paypal, :conditions => ['type = ?', 'PaypalAccount']
  named_scope :webmoney, :conditions => ['type = ?', 'WebMoneyAccount']

  # state scopes
  named_scope :unverified, :conditions => ['state = ?', 'unverified']
  named_scope :pending, :pending => ['state = ?', 'pending']
  named_scope :verified, :conditions => ['state = ?', 'verified']
  named_scope :was_verified, :conditions => "verified_at IS NOT NULL and state != 'unverified'"
  named_scope :processing, :conditions => ['state = ?', 'processing']
  named_scope :removed, :conditions => ['state = ?', 'removed']
  named_scope :rejected, :conditions => ['state = ?', 'rejected']
  
  aasm_column :state
  aasm_initial_state :unverified
  aasm_state :unverified
  aasm_state :pending,  :enter => :when_pending
  aasm_state :rejected, :enter => :when_rejected
  aasm_state :verified, :enter => :when_verified
  aasm_state :processing, :enter => :when_processing
  aasm_state :removed, :enter => :when_removed
    
  aasm_event :pending do
    transitions :from => [:unverified, :processing], :to => :pending
  end
  
  aasm_event :reject do
    transitions :from => [:unverified, :pending, :processing], :to => :rejected
  end
  
  aasm_event :verify do
    transitions :from => [:verified, :unverified, :pending, :processing], :to => :verified
  end
  
  aasm_event :processing do
    transitions :from => [:unverified, :pending], :to => :processing
  end
  
  aasm_event :remove do
    transitions :from => [:removed, :unverified, :pending, :processing, :verified, :rejected], :to => :removed
  end
  # Overriding destroy to prevent *actual* deletion
  def destroy(options = {})
    transaction do
      self.update_attribute(:deleted_at, Time.now)
      if self.state
        remove! unless removed?
      else
        self.update_attribute(:state, 'removed')
        when_removed
      end
    end
  end
    
  def display_status
    return ('Deleted (%s)' / [deleted_at.to_s]) unless deleted_at.blank?
    case state
    when 'pending'
      'Pending Admin Approval'.t
    when 'verified'
      'Verified'
    when 'rejected'
      'Rejected'
    when 'processing'
      'Processing'
    else
      raise "This account is not in a recognized state: #{self.inspect}"
    end
  end
  
  def is_view_permitted?(user_or_actor = nil)
    user_or_project = self.current_user unless user_or_project
    if project
      return true if project.project_founders_include?(user_or_project)
    else
      return true if user_or_project == user
    end
    false
  end

  def self.paginate_with_users(options)
    self.paginate(:all, {:select => 'monetary_processor_accounts.*', :joins => %Q{
      inner join account_settings on monetary_processor_accounts.account_setting_id = account_settings.id
      inner join users on account_settings.user_id = users.id
    }}.merge(options))
  end
  
  # override this in extended classes to handle withdrawals per processor
  def process_withdrawal(withdrawal)
    raise 'WithdrawalAbilitiesNotDefinedForThisProcessor'
  end

  protected
  
  # Additional hooks to be overridden in each child STI class.
  
  def when_verified
    self.verified_at = Time.now
    add_user_to_kroogi_money
  end

  def add_user_to_kroogi_money
    km_user = User.find_by_login('kroogi-money')
    user = self.account_setting.user
    return unless km_user 
    Relationship.create!(:user_id => km_user.id, :related_user_id => user.id,
                         :relationshiptype_id => 1) unless user.is_a_follower_of?(km_user)
  end
  
  def when_rejected
  end
  
  def when_processing
  end
  
  def when_removed
  end

  def when_pending
    AdminNotifier.async_deliver_requires_admin_attention(self)
  end

end
