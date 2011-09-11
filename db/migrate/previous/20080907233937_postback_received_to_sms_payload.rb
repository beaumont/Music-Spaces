class PostbackReceivedToSmsPayload < ActiveRecord::Migration
  def self.up
    add_column :sms_payloads, :postback_received_at, :datetime, :default => nil
    add_column :sms_payloads, :postback_responded_to_successfully_at, :datetime, :default => nil
  end

  def self.down
    remove_column :sms_payloads, :postback_received_at
    remove_column :sms_payloads, :postback_responded_to_successfully_at
  end
end
