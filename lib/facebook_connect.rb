module FacebookConnect
  module Rails
    module Controller

      def self.included(controller)
        controller.helper_method :current_fb_connected_user
      end

      def current_fb_connected_user
        fetch_user
        @_current_fb_connected_user
      end

      def current_fb_session_key
        fetch_user
        @_current_fb_session_key
      end

      def fetch_user
        return if @_fb_user_fetched
        fetch_user_from_cookie
        @_fb_user_fetched = true
      end

      def fetch_user_from_cookie
        fb_cookie = cookies["fbs_#{FB_CONNECT_CONFIG[:app_id]}"]
        return unless fb_cookie
        params = CGI::parse(fb_cookie.gsub('"', ''))
        access_token = params['access_token']
        @_current_fb_session_key = params['session_key'].to_s
        @_current_fb_connected_user = Mogli::User.find("me",Mogli::Client.new(access_token.to_s))
      rescue Exception => e
        logger.info "exception while calling FB open Graph API : #{e}"
      end

      def content_is_safe_to_fb_like(entry)
        return false unless entry
        return true if RAILS_ENV == 'production'
        APP_CONFIG.fb_like_enabled_contents.include?(entry.id.to_s) if APP_CONFIG.fb_like_enabled_contents
      end

      # used for test, lets not proceed on real Kroogi Voting for those content
      # Like happen on Facebook but persistence is disabled on Kroogi
      def kroogi_voting_disabled_for_test(entry)
        return false unless entry
        return false if RAILS_ENV == 'production'
        APP_CONFIG.fb_like_enabled_contents.include?(entry.id.to_s) if APP_CONFIG.fb_like_enabled_contents
      end

      def self.included(base)
        base.send :helper_method, :is_auth_from_facebook?, :content_is_safe_to_fb_like, :current_fb_connected_user, :current_fb_session_key
      end
    end
  end
  
end
