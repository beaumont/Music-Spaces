class CreateSmsPayloads < ActiveRecord::Migration
    def self.up
    create_table :sms_payloads, :options => "auto_increment = 1000" do |t|
      t.integer :from_user_id, :to_account_setting_id, :payment_for_id
      t.string  :payment_for_type
      t.timestamps
    end
    add_index :sms_payloads, :from_user_id
    add_index :sms_payloads, :to_account_setting_id
    add_index :sms_payloads, [:payment_for_type, :payment_for_id]
  end

  def self.down
    drop_table :sms_payloads
  end
end

