# This module is included in the MonetaryDonation model to support WebMoney
module DonationProcessors
  module Webmoney
    include Base
    include LegacyIdHash
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      # create a record from webmoney parameters passed by IPN
      def from_webmoney_params(params)
        returning (find_by_token_and_monetary_processor_id(params[:LMI_SYS_TRANS_NO], MonetaryProcessor.webmoney_all.workers.map(&:id)) || self.new) do |mc|
          begin
            params[:item_name] = Iconv.iconv('utf-8', 'windows-1251//IGNORE', params[:item_name]).first
          rescue => e
            AdminNotifier.async_deliver_alert("Attention: couldn't decode WM item description: #{params[:item_name].to_yaml}. Exception we got: #{e.inspect}")
            params[:item_name] = "[couldn't decode]"
          end
          params[:LMI_PAYMENT_DESC] = params[:item_name] #this also goes to database so let's avoid blowing up
          mc.params = params.with_indifferent_access
          mc.receiver_account_setting_id, mc.content_id, sender_user_id, mc.karma_point_id = params.values_at(:user_acc,:ann_id,:p_id,:karma_point_id).collect{ |p| LegacyIdHash.id_from_hash(CGI::unescape(p || "")) }
          mc.content_type = params[:content_type]
          mc.content_type = 'Content' if mc.content_type.blank?
          download = (params[:download] != 'false')
          mc.sender_account_setting_id = User.find_by_id(sender_user_id).try(:account_setting).try(:id) if sender_user_id
          mc.gross_amount = mc.params[:LMI_PAYMENT_AMOUNT].to_f
          mc.item_name = mc.params[:item_name]
          curr_map = {
            :r => "RUR",
            :z => "USD",
            :e => "EUR"
          }.with_indifferent_access
          mc.currency = curr_map[mc.params[:LMI_PAYEE_PURSE][/^[rze]/i].downcase] rescue nil
          mc.token ||= mc.params[:LMI_SYS_TRANS_NO]
          mc.sender_email = mc.params[:guest_email]
          mc.monetary_processor   = MonetaryProcessor.find_by_short_name('webmoney_%s' % mc.currency.downcase)
        end
      end
    end

  end
end
