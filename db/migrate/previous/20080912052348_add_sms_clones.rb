class AddSmsClones < ActiveRecord::Migration
  def self.up
    add_column :sms_payloads, :cloned_from_id, :integer
  end

  def self.down
    remove_column :sms_payloads, :cloned_from_id
  end
end
