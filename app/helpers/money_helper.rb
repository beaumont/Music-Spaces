module MoneyHelper
  def disable_unless_approved(account_setting)
   %{<div class="disabled_screen">&nbsp;</div>} unless account_setting.money_approved? && account_setting.has_an_approved_account_set?
  end

  def purpose(contrib, options={})
    options.reverse_merge!({
      :truncate => nil
    })
    if contrib.content
      orig_title = title = h(contrib.content.title) || contrib.item_name
      title = truncate(title, :length => options[:truncate]) if options[:truncate]
      link_to(title, {:controller => "/content", :action => "show", :id => contrib.content_id}, :title => (orig_title if title.length < orig_title.length))
    else
      # No content, so point them at the receiver
      user_link(contrib.receiver.user)
    end
  end
  
  def title_for_money_collection(name)
    if name.to_s == 'donations_received'
      if @content
        'Contributions Received for %s' / @content.title
      else
        'Contributions Received'.t
      end
    elsif name.to_s == 'donations_made'
      "Contributions Sent".t
    else
      ''
    end
  end
  
  def view_all_link(user, where_to)
    unless instance_variable_get("@#{where_to}").empty?
      link = %{<div class="i_more">}
      link << link_to( "#{'View All'.t}", user_url_for(user, :action => where_to, :controller => "money") )
      link << %{</div>}
      link 
    end
  end
  
  def active_sort_class(text, sort)
    return text unless params[:sort_by] == sort
    %{<span class="active">#{sort_link(sort, params[:dir], text)}</span>}
  end
  
  def sort_link(by, dir, text = nil, options={})
    up, down = "&uarr;", "&darr;"
    opp_dir = (dir == "asc") ? "desc" : "asc"
    text ||= (dir == "asc") ? down : up
    link = %{<span class="arrow_btn">}
    link << link_to( text, :controller => @controller.request.path,
      :action => nil, :content_id => @content, :dir => opp_dir,
      :sort_by => by)
    link << %{</span>}
    link
  end

  def contrib_processor_name(contrib)
    contrib.processor_name ? contrib.processor_name.t : 'Not specified'.t
  end

  def withdrawal_limit_message(account_setting)
    'Your summary withdrawal limit is ${{amount}}. You must obtain Personal Passport, and re-attach Webmoney pursue or contact Customer Service to make more withdrawals.' /
            account_setting.withdrawal_limit
  end
end
