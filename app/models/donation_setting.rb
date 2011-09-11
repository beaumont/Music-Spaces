# == Schema Information
# Schema version: 20090211222143
#
# Table name: currency_types
#
#  id                                    :integer(11)     not null, primary key
#  accountable_id                        :integer(11)
#  accountable_type                      :string(255)     default("AccountSetting")
#  roubles                               :decimal(10, 2)
#  euros                                 :decimal(10, 2)
#  dollars                               :decimal(10, 2)
#  created_at                            :datetime
#  updated_at                            :datetime
#  sponsorship_prices                    :boolean(1)
#  show_donation_button                  :boolean(1)
#  donation_button_label                 :string(255)
#  message_to_donors                     :text
#  message_to_donors_ru                  :text
#  donation_button_label_ru              :string(255)
#  message_to_donors_fr                  :text
#  donation_button_label_fr              :string(255)
#  amount_required_for_circle_invite_usd :decimal(10, 2)
#  circle_to_invite_to                   :integer(11)
#  amount_required_for_circle_invite_rur :decimal(10, 2)
#  amount_required_for_circle_invite_eur :decimal(10, 2)
#

class DonationSetting < ActiveRecord::Base
  belongs_to :accountable, :polymorphic => true
  before_save :set_defaults
  
  translates :donation_button_label, :message_to_donors, :base_as_default => true
  
  protected
  
  def set_defaults
    (self.message_to_donors = "Thank you for your contribution".t) if self.message_to_donors.blank?
    self.donation_button_label = self.donation_button_label.blank? ? 'Contribute Now'.t : self.donation_button_label.chars[0...35]
  end
  
end
