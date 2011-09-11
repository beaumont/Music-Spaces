class SmsPayloadConnectsToMonetaryContribution < ActiveRecord::Migration
  def self.up
    add_column :monetary_contributions, :sms_payload_id, :integer
  end

  def self.down
    remove_column :monetary_contributions, :sms_payload_id
  end
end
