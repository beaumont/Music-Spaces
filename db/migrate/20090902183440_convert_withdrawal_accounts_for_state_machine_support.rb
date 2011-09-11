class ConvertWithdrawalAccountsForStateMachineSupport < ActiveRecord::Migration
  def self.up
    # this is a state machine now..
    rename_column :monetary_processor_accounts, :status, :state
    
    # handled at the account setting level..
    remove_column :monetary_processor_accounts, :minimum_account_level
    
    # split the paypal account and state for all paypal accounts
    PaypalAccount.find(:all).each do |p|
      begin
        p.update_attribute(:state, p.state.scan(/(.*):.*/).flatten[0])
      rescue
        log.warn 'no state for account '
        p.state = nil
      end
    end
    
  end

  def self.down
    add_column :monetary_processor_accounts, :minimum_account_level, :integer,  :default => 130
    rename_column :monetary_processor_accounts, :state, :status
  end
end
