class LikePublisher < Facebooker::Rails::Publisher
  def like(user, entry, entry_url)
    return unless user.facebook_connected?
    fb_user = user.facebook_session.user

    send_as :publish_stream
    from fb_user
    target fb_user
    message entry_url
  end
end
