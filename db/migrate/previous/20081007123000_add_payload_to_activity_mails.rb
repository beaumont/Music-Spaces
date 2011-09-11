class AddPayloadToActivityMails < ActiveRecord::Migration
  def self.up
    add_column :activity_mails, :payload, :string
  end

  def self.down
    remove_column :activity_mails, :payload
  end
end
