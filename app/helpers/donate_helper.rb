module DonateHelper
  def en_payment_description(recipient, content)
    result = "Contribute to '#{recipient._display_name.blank? ? recipient.login : recipient._display_name}'"
    I18n.with_locale('en') do
      result << " for '#{Russian.translit(content.title)}'" if content && !content.title.blank?
    end
    result
  end

  def suggested_contribution_amount(content, processor)
    if processor.is_a?(String)
      currency = processor
    else
      currency = processor ? processor.currency : 'USD'
    end
    result = content.recommended_contribution_amount || content.min_contribution_amount if content
    result ||= 5
    if result.to_f == 0.01
      result = processor.minimum_possible unless processor.is_a?(String)
    elsif currency && currency.downcase != 'usd'
      localized = CashHandler::Base.instance.convert(result.to_f, 'USD', currency)
      if localized == 1.0/0
        localized = result
      elsif localized > result * 10
        localized  = (localized / 10).ceil * 10
      else
        localized  = (localized * 10).ceil.to_f / 10
      end
      result = localized
    end
    '%.2f' % result
  end

  def check_min_contribution_js_function(content, p)
    #'RUR'.t 'USD'.t 'EUR'.t
    min_amount = suggested_contribution_amount(content, p)
    %Q{
      function check_min_conribution_#{params[:dialog_id_suffix]}_#{p.short_name}(amount) {
        if (amount < #{min_amount}) {
          jQuery('#donation_dialog_error_messages_#{params[:dialog_id_suffix]}').html("#{"Minimum contribution required here is {{amount}} {{currency}}" /
            [min_amount, p.currency.upcase.t] }");
          return false;
        }
        return true;
      }
    }
  end
end
