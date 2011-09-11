require 'donation_processors/smscoin'
module DonationProcessors
  def self.processors
    [Paypal, MovableBroker, Webmoney, Yandex, ::DonationProcessors::Smscoin]
  end

  def self.in_successful_payment_handler?(controller)
    processors.any? {|p| p.in_successful_payment_handler?(controller)}
  end
end