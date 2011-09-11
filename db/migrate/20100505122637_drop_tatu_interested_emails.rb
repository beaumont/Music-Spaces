class DropTatuInterestedEmails < ActiveRecord::Migration
  def self.up
    drop_table :tatu_interested_emails
  end

  def self.down
  end
end
