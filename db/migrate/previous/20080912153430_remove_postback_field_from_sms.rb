class RemovePostbackFieldFromSms < ActiveRecord::Migration
  def self.up
    remove_column :sms_payloads, :postback_responded_to_successfully_at
  end

  def self.down
    add_column :sms_payloads, :postback_responded_to_successfully_at, :datetime
  end
end
