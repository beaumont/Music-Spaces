module Facebook
  class Page < ::User
    has_one :details, :class_name => 'Facebook::UserDetails', :foreign_key => "user_id", :dependent => :delete

    def self.find_or_create(fb_user_id, facebook_session)
      page = UserDetails.find_page(fb_user_id)
      if page
        unless facebook_session.nil?
          page.details.maybe_update(facebook_session.session_key)
        end
        yield(page) if block_given?
      else
        page = self.new(:login => fb_user_id.to_s, :crypted_password => "", :email => "")
        fb_session_key = facebook_session.nil? ? nil : facebook_session.session_key
        self.transaction do
          page.save_without_validation!
          page.create_details(:fb_user_id => fb_user_id, :fb_session_key => fb_session_key)
          page.preference.update_attribute(:email_notifications, Preference::EMAIL[:none])
        end
      end
      page
    end
    
    def facebook_id
      self.details.fb_user_id
    end

    def linked_artist_id
      self.details.linked_artist_id
    end

    def header_text
      self.details.header_text
    end

    def self.find_by_fb_page(fb_page_id)
      UserDetails.find_page(fb_page_id)
    end

    def is_linked_to_artist?
      !self.details.linked_artist_id.nil?
    end

    def default_circles
      []
    end
  end
end

