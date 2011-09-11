xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0", 'xmlns:atom' => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title "%s's Kroogi Activity" / h(@user.login)
    xml.description "Stay up-to-date on %s's Kroogi activities" / h(@user.login)
    xml.link "http://#{APP_CONFIG[:hostname]}" + user_feed_path(@user)
    xml.<< "<atom:link rel=\"self\" href=\"http://#{APP_CONFIG[:hostname]}#{user_feed_path(@user)}\" />\n"
    xml.language( I18n.locale ) if I18n.locale
    xml.pubDate @activities.first.created_at.to_s(:rfc822) unless @activities.empty?
    
    for activity in @activities
      xml.item do
        xml.title activity.keyname.to_s.humanize
        xml.link "#{@link}#activity_#{activity.id}"
        xml.guid "#{@link}#activity_#{activity.id}"
        xml.description {
          body_string = h(@user.login) + ' ' + render(:partial => '/activity/activity.html.erb', :locals => {:activity => activity, :citation_length => 20, :one_liner => true})
          if activity.content.is_a?(Image)
            body_string += '<br/>' + image_tag(activity.content.thumb(:big).public_filename, :alt => activity.content.title_short)
          end
          xml.cdata! body_string
        } 
        xml.pubDate activity.created_at.to_s(:rfc822)
      end
    end
  end
end