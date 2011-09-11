module Facebook::DonateHelper

  def visiblity_for_additional_mps(opts = {})
    values = {:show => 'display:block', :hide => 'display:none'}
    viewer_inteface_language == 'RU' ? values[:show] : values[:hide]
  end

  def validate_donation_form_script(ps,element,other_field_to_highlight,item,box)
    p = MonetaryProcessor.find_by_short_name(ps)
    func1 = <<-HTML
      <script>
        function verify_amount_#{ps}_#{box}() {
          if(document.getElementById('#{element}_#{box}').getValue() == "")
          {
              document.getElementById('#{element}_#{box}').setStyle('background-color','red');
              document.getElementById('#{other_field_to_highlight}_#{box}').setStyle('color','red').setStyle('display','block');
              return false;
          }
    HTML
    unless item.min_contribution_amount.nil?
      func2 = <<-HTML
       else if(#{!item.min_contribution_amount.nil?} && document.getElementById('#{element}_#{box}').getValue() < #{suggested_contribution_amount(item, p)})
          {
            document.getElementById('#{element}_#{box}').setStyle('background-color','red');
            document.getElementById('min_contrib_warning_#{ps}_#{box}').setStyle('color','red').setStyle('display','block');
            document.getElementById('#{other_field_to_highlight}_#{box}').setStyle('display','none');
            return false;
          }
      HTML
    end
    func3 = <<-HTML
      else if(document.getElementById('#{element}_#{box}').getValue() == 0)
          {
            document.setLocation('#{fb_content_link(item,:payment_gross=>0)}');
            return false;
          }
      else {
            return true;
           }
        }
      </script>
   HTML
   text = func1
   text << func2 if func2
   text << func3
   text
  end
  
end