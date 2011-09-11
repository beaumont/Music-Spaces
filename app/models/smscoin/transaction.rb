#
#  create_table "smscoin_transactions", :force => true do |t|
#    t.column "cost_option_id",       :integer,  :null => false
#    t.column "recipient_id",         :integer,  :null => false
#    t.column "content_id",           :integer
#    t.column "donor_id",             :integer
#    t.column "karma_point_id",       :integer
#    t.column "state",                :string,   :null => false
#    t.column "return_url",           :string,   :null => false
#    t.column "monetary_donation_id", :integer
#    t.column "created_at",           :datetime
#    t.column "updated_at",           :datetime
#  end
#

module Smscoin
  class Transaction < ActiveRecord::Base
    set_table_name 'smscoin_transactions'

    belongs_to  :recipient, :class_name => 'User'
    belongs_to  :donor, :class_name => 'User'
    belongs_to  :content, :polymorphic => true
    belongs_to  :monetary_donation

    include AASM

    aasm_column :state
    aasm_initial_state :user_didnt_comeback
    aasm_state :user_didnt_comeback
    aasm_state :cameback_with_success
    aasm_state :cameback_with_failure

    aasm_event :succeed do
      transitions :from => [:user_didnt_comeback, :cameback_with_failure], :to => :cameback_with_success
    end

    aasm_event :cancel do
      transitions :from => [:user_didnt_comeback], :to => :cameback_with_failure
    end

    def cost_option
      CostOption.new(YAML.load(cost_option_dump))
    end

    def cost_option=(value)
      self.cost_option_dump = value.attributes.to_yaml
    end
    
    def create_monetary_donation!(net_usd, controller)
      net_usd = BigDecimal(net_usd)
      if Smscoin::CostOption.equal_costs?(net_usd, cost_option.net_usd) 
        log.debug "looks like user didn't change provider at SmsCoin"
        gross = cost_option.gross_usd 
      else
        gross = Smscoin::Version.guess_gross(net_usd)
        unless gross
          AdminNotifier.async_deliver_admin_alert("Smscoin sent us net that doesn't exist in their tariffs! Please investigate. Params are #{controller.params.inspect}, env is #{controller.request.env.inspect}")
          gross = net_usd
        end
      end

      token = controller.params['s_inv']
      if donation = MonetaryDonation.find_by_token_and_monetary_processor_id(token, MonetaryProcessor.smscoin.id)
        if controller.params != donation.params
          AdminNotifier.async_deliver_admin_alert("Warning - Smscoin postback with different params received for already registered donation. Params are #{controller.params.inspect}, env is #{controller.request.env.inspect}")
        end
        return
      end

      md = MonetaryDonation.create!({
              :receiver_account_setting_id => self.recipient.account_setting.id,
              :sender_account_setting_id => self.donor ? self.donor.account_setting.id : -1,
              :content_id => self.content_id,
              :content_type => self.content_type,
              :currency => 'usd',
              :monetary_processor_id => MonetaryProcessor.smscoin.id,
              :gross_amount => gross, #let's have all in usd - there are plenty of currencies in SmsCoin but it's not really important as they give us sums in USD, too
              :monetary_processor_fee => gross - net_usd,
              :params => controller.params,
              :token => token,
              :karma_point_id => self.karma_point_id,
      })
      self.update_attribute(:monetary_donation_id, md.id)
    end
  end
end
