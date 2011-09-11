module AccountHelper
  
  # most AccountSetting models in the database have a default of
  # "'Please donate...'" set in their CurrencyType object.
  # this overrides that without needing to make 
  # a big ass migration.
  def default_donation_message(account_setting, locale)
    (account_setting.message_to_donors == 'Please contribute...'.t) ? "Thank you for your contribution!".t : account_setting.message_to_donors
  end
end