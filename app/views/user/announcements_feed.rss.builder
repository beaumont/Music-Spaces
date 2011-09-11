xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0", 'xmlns:atom' => "http://www.w3.org/2005/Atom", 'xmlns:media' => "http://search.yahoo.com/mrss/" do
  xml.channel do
    xml.title "Kroogi: {{username}}'s Announcements and Notes" / h(@user.login)
    xml.description "Stay up-to-date on {{username}}'s announcements and notes" / h(@user.login)
    xml.link profile_page_url(@user)
    xml.language(I18n.locale)
    xml.pubDate @announcements.first.created_at.to_s(:rfc822) unless @announcements.empty?

    for announcement in @announcements
      unless announcement.post.nil?
        xml.item do
          xml.title announcement.title(100).to_s.humanize
          xml.link content_url(announcement)
          xml.guid content_url(announcement)
          image = announcement.embedded_image
          xml.description {
            body_string = kf_simple(announcement.post,
                                    :tags => %w(a),
                                    :attributes => %w(id onclick style))
            if image
              body_string += '<br/>' + image_tag(image.thumb(:big).public_filename, :alt => image.title_short)
            end
            xml.cdata! body_string
          }
          xml.pubDate announcement.created_at.to_s(:rfc822)
          if image
            image = image.thumb(:big)
            xml.<< "<media:thumbnail url=\"#{image.public_filename}\" width=\"#{image.width}\" height=\"#{image.height}\" />"
          end
        end
      end
    end
  end
end
