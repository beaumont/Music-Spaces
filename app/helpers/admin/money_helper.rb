module Admin::MoneyHelper
  include ::MoneyHelper

  def top_select_items
    [['',nil], ['[%s]' % 'Not specified'.tdown, -1]]
  end

  def options_for_sender_select(selected_id)
    all = top_select_items + User.find(:all,
      :select => "id,login,type", :order => "login ASC").
      collect {|u| [u.login,u.id]}    
    options_for_select(all, selected_id)
  end

  def export_to_csv_link
    p = params.merge(:action => 'query.csv')
    p.delete('commit')
    p.delete('page')
    p.delete('page_size')
    link_to '[%s]' % 'Export to CSV'.t, p
  end

  def currency(contrib)
    h(contrib.currency || 'Not specified'.t) + ' ' + link_to('[%s]' % 'that currency'.t,
        {:action => :query, 'query[currency]' => contrib.currency || -1},
        :title => 'show all contributions in that currency'.t,
        :class => 'restrict_query')
  end

  def money_user_link(user, options)
    (user ? user_link(user, :icon => true) : 'Guest User'.tdown) + ' ' +
      link_to('<br />[%s]' % options[:label], {:action => :query,
        'query[%s]' % options[:param] => user ? user.login : 'guest'},
        :title => options[:title],
        :class => 'restrict_query')
  end
  
  def money_balance_link(user, options={})
      link_to('%s' % options[:label], {
        :action => :balance,
        :user => user.login},
        :title => options[:title])
  end
  
  def class_display(type)
    type.class.name.titleize.gsub('Monetary ','')
  end
end
