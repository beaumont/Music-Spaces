class AddingPaypalValidationStatus < ActiveRecord::Migration
  def self.up
    AccountSetting.transaction do
      unless AccountSetting.column_names.include?('paypal_status')
        add_column :account_settings, :paypal_status, :string, :nil => true
        add_column :account_settings, :paypal_status_last_updated_at, :datetime
        add_column :account_settings, :paypal_status_last_updated_by, :integer
        add_index :account_settings, :paypal_status
      end
    
      # Do pending first, so we don't revert any accounts that are marked w/ both
      AccountSetting.update_all 'paypal_status="pending"', ["paypal_pending=?", true]
      AccountSetting.update_all 'paypal_status="verified"', ["paypal_verified=?", true]
      
      # Set the updated date as appropriate
      kroogi = User.lnkroogi 
      kroogi_id = kroogi ? kroogi.id : 0
      AccountSetting.update_all ['paypal_status_last_updated_at=?, paypal_status_last_updated_by=?', Time.now, kroogi_id ], ["paypal_status=? or paypal_status=?", 'pending', 'verified']
    
      remove_column :account_settings, :paypal_pending
      remove_column :account_settings, :paypal_verified
    end
  end

  def self.down
    AccountSetting.transaction do
      add_column :account_settings, :paypal_pending, :boolean
      add_column :account_settings, :paypal_verified, :boolean
    
      AccountSetting.update_all ["paypal_pending=?", true], 'paypal_status="pending"'
      AccountSetting.update_all ["paypal_verified=?", true], 'paypal_status="verified"'
    
      remove_column :account_settings, :paypal_status
      remove_column :account_settings, :paypal_status_last_updated_at
      remove_column :account_settings, :paypal_status_last_updated_by
    end
  end
end
