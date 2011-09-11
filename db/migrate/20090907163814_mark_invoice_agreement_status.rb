class MarkInvoiceAgreementStatus < ActiveRecord::Migration
  def self.up
    transaction do
      MonetaryProcessorAccount.verified.select{|mpa| !mpa.account_setting.nil?}.each{|mpa| mpa.account_setting.invoice_agreement_accepted_at = Time.now; mpa.account_setting.save(false)}
    end
  end

  def self.down
    transaction do
      MonetaryProcessorAccount.verified.select{|mpa| !mpa.account_setting.nil?}.each{|mpa| mpa.account_setting.invoice_agreement_accepted_at = nil;      mpa.account_setting.save(false)}
    end
  end
end
