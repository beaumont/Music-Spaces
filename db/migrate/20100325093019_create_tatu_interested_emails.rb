class CreateTatuInterestedEmails < ActiveRecord::Migration
  def self.up
    create_table :tatu_interested_emails, :force => true do |t|
      t.string :email
    end
  end

  def self.down
  end
end
