# == Schema Information
# Schema version: 20090211222143
#
# Table name: web_money_transfers
#
#  id                          :integer(11)     not null, primary key
#  receiver_account_setting_id :string(255)
#  sender_account_setting_id   :string(255)
#  source_wmid                 :string(255)
#  destination_wmid            :string(255)
#  purse_type                  :integer(11)
#  amount                      :string(255)
#  success                     :boolean(1)
#  response                    :text
#  created_at                  :datetime
#  updated_at                  :datetime
#

class WebMoneyTransfer < ActiveRecord::Base
  belongs_to :ticket, :class_name => 'WebMoneyTicket', :foreign_key => 'web_money_ticket_id'
  
  before_create :generate_ticket

  def request_number
    web_money_ticket_id
  end
    
  protected
  
  def generate_ticket
    self.ticket = WebMoneyTicket.create!
  end
  
end
