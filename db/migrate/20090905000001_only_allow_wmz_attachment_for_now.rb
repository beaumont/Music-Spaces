class OnlyAllowWmzAttachmentForNow < ActiveRecord::Migration
  def self.up
    MonetaryProcessor.update_all('allow_withdrawal = false')
    MonetaryProcessor.update_all('allow_withdrawal = true', ['short_name in (?)', ['webmoney_usd', 'paypal']])
  end

  def self.down
  end
end
