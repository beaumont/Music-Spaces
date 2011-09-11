#  create_table "tps_goodie_tickets", :force => true do |t|
#    t.column "goodie_id",          :integer,                                 :null => false
#    t.column "buyer_id",           :integer,                                 :null => false
#    t.column "state",              :string,                                  :null => false
#    t.column "title",              :string
#    t.column "price",              :decimal,  :precision => 10, :scale => 2
#    t.column "created_at",         :datetime
#    t.column "updated_at",         :datetime
#    t.column "content_id",         :integer,                                 :null => false
#  end
#
module Tps
  class GoodieTicket < ActiveRecord::Base
    set_table_name 'tps_goodie_tickets'

    include AASM
    belongs_to :goodie, :class_name => 'Tps::Goodie'
    belongs_to :buyer, :class_name => 'User'
    belongs_to :content
    has_one :payment, :class_name => 'MonetaryTransaction', :as => 'content'

    aasm_column :state
    aasm_initial_state :pending
    aasm_state :pending
    aasm_state :active, :enter => :do_activate
    aasm_state :succeeded, :enter => :do_succeed

    aasm_event :activate do
      transitions :from => :pending, :to => :active
    end

    aasm_event :succeed do
      transitions :from => :active, :to => :succeeded
    end

    before_destroy :revert

    named_scope :unfinished, :conditions => ['state != ?', 'succeeded']
    named_scope :pending, :conditions => ['state = ?', 'pending']
    named_scope :of_buyer, lambda {|buyer| { :conditions => ['buyer_id = ?', buyer.id]} }
    named_scope :of_hat, lambda {|hat| { :conditions => ['tps_goodie_tickets.content_id = ?', hat.id]} }
    named_scope :picked, :conditions => ['tps_goodie_tickets.state != ?', 'pending']
    named_scope :paid, :conditions => ['state = ?', 'succeeded']
    named_scope :updated_before, lambda {|time| { :conditions => ['updated_at < ?', time]} }
    named_scope :fresh_first, :order => 'id desc'
    named_scope :ordered_by_goodie_title, :order => 'tps_goodies.title desc'
    named_scope :with_goodies, :include => :goodie
    named_scope :with_contents, :joins => "JOIN tps_goodies on tps_goodies.id = tps_goodie_tickets.goodie_id JOIN contents on contents.id = tps_goodies.content_id" 
    named_scope :non_tps, :conditions => ['contents.type != ?', 'Tps::Content']
    named_scope :non_virtual, :conditions => ['tps_goodies.needs_document || tps_goodies.needs_address']

    %w(content_id content).each do |attr_name|
      delegate attr_name.to_sym,       :to => :goodie
    end

    %w(user).each do |attr_name|
      delegate attr_name.to_sym,       :to => :content
    end
    alias :artist :user

    def min_contribution_amount
      goodie.price
    end

    alias :recommended_contribution_amount :min_contribution_amount

    def tps_ticket?
      content.is_a?(Tps::Content)
    end

    def do_activate
      content.inc_participated_count if tps_ticket?
      goodie.update_attribute(:left, goodie.left - 1) if goodie.left
      self.update_attributes!(:price => goodie.price, :title => goodie.title) #store for reference
    end

    def revert
      return false if self.succeeded? #don't remove succeeded at all
      return true unless self.active?

      content.dec_participated_count if tps_ticket?
      goodie.update_attribute(:left, goodie.left + 1) if goodie.left
    end

    def do_succeed
      if self.goodie.downloadable?
        Activity.send_message(self, self.buyer, :content_download_link_given)
      end
      Activity.send_message(self, self.buyer, tps_ticket? ? :tps_goodie_bought : :goodie_bought)
      create_or_update_participant
    rescue Exception => e
      AdminNotifier.async_deliver_admin_alert("do_succeed transition of goodie ticket #{self.id} failed:\n #{e.inspect}")
    end

    def title
      read_attribute(:title) || goodie.title
    end

    def succeed_with_donation(transaction)
      self.class.transaction do
        self.succeed!
        content.details.increase_collected(transaction.net_amount_usd) if tps_ticket?
      end
    end

    alias :title_long :title

    def create_or_update_participant
      return unless self.goodie.needs_address? || self.goodie.needs_document?
      conditions = {:content_id => self.content_id, :user_id => self.buyer_id}
      participant = Participant.find(:first, :conditions => conditions)
      participant ||= Participant.new(conditions)
      participant.address_missing = true if participant.address_missing.nil? && self.goodie.needs_address?
      participant.document_missing = true if participant.document_missing.nil? && self.goodie.needs_document?
      participant.save!
    end
    
  end
end