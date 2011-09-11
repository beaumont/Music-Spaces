class ConvertLegacyDonationData < ActiveRecord::Migration
  def self.up
    transaction do
      ###### RAW SQL for basic migration
      MonetaryTransaction.connection.execute("delete from monetary_transactions")
      MonetaryTransaction.connection.execute("ALTER TABLE monetary_transactions AUTO_INCREMENT=1")

      MonetaryTransaction.connection.execute("insert into monetary_transactions
      (id, content_id, receiver_account_setting_id, sender_account_setting_id, monetary_processor_log,
       conversion_rate, suspicious, token, billable, user_kroog_id, invite_id, item_name, created_at, updated_at,
       type, paid, handling_fee_usd, applied_to_balance, sms_payload_id, sender_email, gross_amount_usd)
      select c.id, c.content_id, c.account_setting_id, a.id, c.param_set, 
        c.conversion_rate, c.suspect, c.token, c.billable, c.user_kroog_id, c.invite_id, c.item_name, c.created_at, c.updated_at,
       'MonetaryDonation', 1, 0, 0, c.sms_payload_id, c.payer_email, c.gross_usd
      from monetary_contributions as c
      left join users as u on c.payer_id = u.id
      left join account_settings as a on a.user_id = u.id")

      # Make sure we are well out of range for the pkey since we were setting them above and they need to be associated correctly
      MonetaryTransaction.connection.execute("ALTER TABLE monetary_transactions AUTO_INCREMENT=30000")

      # set currency types
      MonetaryTransaction.connection.execute("update monetary_transactions, monetary_contributions set monetary_transactions.currency_id = 1 where monetary_contributions.currency_type = 'USD' and monetary_transactions.id = monetary_contributions.id")
      MonetaryTransaction.connection.execute("update monetary_transactions, monetary_contributions set monetary_transactions.currency_id = 2 where monetary_contributions.currency_type = 'RUR' and monetary_transactions.id = monetary_contributions.id")
      MonetaryTransaction.connection.execute("update monetary_transactions, monetary_contributions set monetary_transactions.currency_id = 3 where monetary_contributions.currency_type = 'EUR' and monetary_transactions.id = monetary_contributions.id")

      # masspays are always USD..
      MonetaryTransaction.connection.execute("update monetary_transactions set currency_id = 1 where currency_id IS NULL and monetary_processor_log like '%masspay_txn_id%'")

      # set monetary processor
      MonetaryTransaction.connection.execute("update monetary_transactions, monetary_contributions set monetary_transactions.monetary_processor_id = 1 where monetary_contributions.payment_api = 'paypal' and monetary_transactions.id = monetary_contributions.id")
      MonetaryTransaction.connection.execute("update monetary_transactions, monetary_contributions set monetary_transactions.monetary_processor_id = 2 where monetary_contributions.payment_api = 'webmoney' and monetary_transactions.id = monetary_contributions.id and monetary_contributions.currency_type = 'USD'")
      MonetaryTransaction.connection.execute("update monetary_transactions, monetary_contributions set monetary_transactions.monetary_processor_id = 3 where monetary_contributions.payment_api = 'webmoney' and monetary_transactions.id = monetary_contributions.id and monetary_contributions.currency_type = 'RUR'")
      MonetaryTransaction.connection.execute("update monetary_transactions, monetary_contributions set monetary_transactions.monetary_processor_id = 4 where monetary_contributions.payment_api = 'webmoney' and monetary_transactions.id = monetary_contributions.id and monetary_contributions.currency_type = 'EUR'")
      MonetaryTransaction.connection.execute("update monetary_transactions, monetary_contributions set monetary_transactions.monetary_processor_id = 5 where monetary_transactions.id = monetary_contributions.id and monetary_contributions.sms_payload_id IS NOT NULL")

      # fix nulls for guest
      MonetaryTransaction.connection.execute("update monetary_transactions set sender_account_setting_id = -1 where sender_account_setting_id is null")

      # nothing is billable yet...
      MonetaryDonation.update_all('billable = 0')
      MonetaryDonation.update_all('handling_fee_usd = 0')
      AccountSetting.update_all('billable = 0')

      MonetaryTransactionObserver.disable
      # set conversion rates/currency amounts for paypal 
      MonetaryDonation.find(:all, :conditions => {:monetary_processor_id => 1}).each do |md|
        p = {}
        mx = md
        if md.monetary_processor_log =~ /instant_payment/
          CGI.parse(md.monetary_processor_log).map{|k,v| p[k] = v[0] }
          mx = MonetaryDonation.from_paypal_params(p.with_indifferent_access)
        end
        mx.save
      end

      # Lets try to get what we can from where we can here... (auth_amount => gross)
      MonetaryTransaction.connection.execute('update monetary_transactions set gross_amount = gross_amount_usd where conversion_rate = 1')
      MonetaryTransaction.connection.execute('update monetary_transactions, monetary_contributions set monetary_transactions.gross_amount = monetary_contributions.auth_amount where monetary_contributions.id = monetary_transactions.id and monetary_transactions.gross_amount = 0;')
      
      # set all sms with no currency to RUR
      MonetaryTransaction.connection.execute('update monetary_transactions set currency_id = 2 where currency_id IS NULL')
      
      # Clean up SMS data
      MonetaryDonation.find(:all, :conditions => {:monetary_processor_id => [5]}).each do |md|
        md.save
      end

      # convert missing transaction/token information and
      # set conversion rates/currency/etc for webmoney where we can....
      MonetaryDonation.find(:all, :conditions => {:monetary_processor_id => [2,3,4]}).each do |md|
        p = {}
        mx = md
        if !md.monetary_processor_log.blank?
          CGI.parse(md.monetary_processor_log).map{|k,v| p[k] = v[0] }
          md.update_attribute(:token, p.with_indifferent_access[:LMI_SYS_TRANS_NO])
          mx = MonetaryDonation.from_webmoney_params(p.with_indifferent_access)
        end
        mx.save
      end
    end
  end

  def self.down
  end
end
