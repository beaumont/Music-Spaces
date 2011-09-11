# shared instance methods for models that has_one :currency_type
module DonationSettingMethods
  module ClassMethods
    attr_accessor :amount_usd, :amount_wmr, :amount_wmz, :amount_wme, 
                  :message_to_donors, :show_donation_button, :donation_button_label,
                  :amount_required_for_circle_invite_usd,
                  :amount_required_for_circle_invite_rur,
                  :amount_required_for_circle_invite_eur
  end
  
  module InstanceMethods
    delegate :circle_to_invite_to, :circle_to_invite_to=, :to => :donation_setting_object
    %w[usd rur eur].each{|cur| delegate("amount_required_for_circle_invite_#{cur}", "amount_required_for_circle_invite_#{cur}=", :to => :donation_setting_object)}
    
    # these are methods in the CurrencyType model that are translatable.
    [:message_to_donors].each do |facet|
      delegate "#{facet}", "#{facet}=", "_#{facet}", "_#{facet}=", "#{facet}_before_type_cast", :to => :donation_setting_object
      delegate "#{facet}_ru", "#{facet}_ru=", "#{facet}_ru_before_type_cast",                   :to => :donation_setting_object
    end
    
    def donation_setting_object
      @donation_setting ||= self.donation_setting.nil? ? self.build_donation_setting : self.donation_setting
    end
    
    def amount_usd
      donation_setting_object.dollars
    end
    
    def amount_wmz
      self.amount_usd
    end
    
    def amount_wme
      donation_setting_object.euros
    end
    
    def amount_wmr
      donation_setting_object.roubles 
    end
    
    def amount_usd=(d)
      donation_setting_object.dollars = d
    end
    
    def amount_wmz=(d)
      self.amount_usd = d
    end
    
    def amount_wme=(d)
      donation_setting_object.euros = d
    end
    
    def amount_wmr=(d)
      donation_setting_object.roubles = d
    end
    
    # to make validating currencies simpler
    alias_method :amount_rur, :amount_wmr 
    alias_method :amount_eur, :amount_wme 
    alias_method :amount_rur=, :amount_wmr= 
    alias_method :amount_eur=, :amount_wme= 
    
    def is_paid?
      %w(amount_usd amount_wmr amount_wme).any?{|m| !self.send(m).nil? } && has_an_approved_account_set?
    end
    
    alias_method :is_paid, :is_paid?
    
    # clear all set amounts
    def clear_amounts
      %w(amount_usd amount_wmr amount_wme).each{|m| self.send("#{m}=", nil) }
    end
    
    # returns the methods that are set like ["amount_usd", "amount_wmr"]
    def amounts_set
      %w(amount_usd amount_wmr amount_wme).select{|m| !self.send(m).blank? }
    end
    
    # returns the amount for the passed in account type (webmoney_wmr etc)
    def amount_for_method(acc_type)
      if acc_type.to_s =~ /webmoney_(wm[re]{1})/
        send("amount_#{$1}")
      elsif acc_type.to_s[/yandex/]
        send("amount_rur")
      else
        send("amount_usd")
      end
    end
    
    # set up for sending circle invites for certain donation amounts: per https://dev.kroogi.com/trac/krugi/ticket/1989
    def invite_to_circle_after_donation?
      circle_invite_amount_set? && !circle_to_invite_to.nil?
    end
    
    protected
    def circle_invite_amount_set?
      %w[usd rur eur].all?{ |cur| !send("amount_required_for_circle_invite_#{cur}").nil? }
    end
    
    def save_donation_setting
      donation_setting_object.save
    end
  end
  
  module AccountMethods
    # these are methods in the CurrencyType model that are translatable.
    [:donation_button_label].each do |facet|
      delegate "#{facet}", "#{facet}=", "_#{facet}", "_#{facet}=", "#{facet}_before_type_cast", :to => :donation_setting_object
      delegate "#{facet}_ru", "#{facet}_ru=", "#{facet}_ru_before_type_cast",                   :to => :donation_setting_object
    end
    
    # These methods are instance methods of AccountSetting and are useful for anything that uses money
    delegate :show_donation_button, :show_donation_button=, :show_donation_button?, :to => :donation_setting_object
    
    def donation_account
      # Changed to try user before author... weird case where album's author was user but user was project... need to check donation account of where the money's going (user)
      return self if self.is_a?(AccountSetting)
      attempt_methods(:inviter, :user, :author).account_setting
    end    
    
    # to avoid massive find/replace
    def donation_account_set?
      donation_account.has_an_approved_account_set?
    end
    
    def can_have_prices_set?
      donation_account.has_an_approved_account_set?
    end
    
    # check if a model can accept donations
    def donatable?
      return can_have_prices_set? if self.new? 
      show_donation_button? && can_have_prices_set?
    end
    
    #--------------------------------------------
    # just in case the default settings come back
    # 
    def amount_required_for_circle_invite_with_default(cur)
      meth = "amount_required_for_circle_invite_#{cur.downcase}"
      val = send(meth)
      val.blank? ? donation_account.send(meth) : val
    end
    
    def circle_to_invite_to_with_default
      val = send(:circle_to_invite_to) 
      val.blank? ? donation_account.send(:circle_to_invite_to) : val
    end
    #--------------------------------------------
  end
  
  def self.included(receiver)
    receiver.extend ClassMethods
    receiver.send :include, InstanceMethods
    receiver.after_save(:save_donation_setting) if receiver.respond_to?(:after_save)
    unless receiver.base_class.name =~ /AccountSetting/
      receiver.send :include, AccountMethods
    end
  end
end
