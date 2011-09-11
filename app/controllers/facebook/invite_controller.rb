class Facebook::InviteController < Facebook::ApplicationController

  def new
    @album = Content.find(params[:ma_id])
    friends =  facebook_session.user.friends
    @excluded_friends_list = []
    friends.each do |friend|
      user = Facebook::User.find_by_fb_user(friend.id)
      if user and (Facebook::User.has_already_received_content?(@album, user, current_fb_user) || Facebook::User.has_content_in_collection?(user, @album.id))
        @excluded_friends_list << friend.id.to_s
      end
    end
  end

  def create
    from = self.current_fb_user
    unless params[:ids].nil?
      recipients = params[:ids].map {|id| Facebook::User.find_or_create(id,nil,{:invited=>true, :is_kd_user => 1})}
      album = Content.find(params[:album])
      recipients.each do |target_user|
        Activity.create_for(target_user, from, album,
                            Activity::ACTIVITIES[:content_invite_sent][:id],
                            {:created_at => params[:created_at], :status => Status::PENDING}, :skip_emails => true
                            )
      end
      flash[:notice] = 'Invite successfully sent'
    end
    redirect_to show_content_path(:id=>params[:album], :canvas=>true)
  end

end
