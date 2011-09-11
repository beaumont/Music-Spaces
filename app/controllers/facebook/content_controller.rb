class Facebook::ContentController < Facebook::ApplicationController
  skip_before_filter :ensure_authenticated_to_facebook, :only => [:show, :content_from_invite]
  protect_from_forgery :except =>[:save_as, :render_feed]
  skip_before_filter :verify_authenticity_token, :only => [:show]

  before_filter :increment_invite_counter,  :only => [:show, :content_from_invite]
  after_filter :increment_download_counter, :only => [:save_as]

  def show
    @entry = Content.find(params[:id])
    @has_donated = params[:payment_gross]
    @template_id = feed_template_id
    unless current_fb_user.nil?
      @friends_list = ImpactCounter.download.with_user(current_fb_user).for_content(@entry).order_by_attr('updated_at','DESC') if @entry
    end
    if @entry.is_a?(MusicAlbum)
      if @entry.qualify_for_fb
        render :action => "show_music_album"
      else
        @other_music_albums = @entry.user.contents.music_albums.select{|ma| ma.qualify_for_fb}
        render :action => "music_album_not_available"
      end
    else
      render :text => "entry is not viewable"
    end
  end

  def content_from_invite
    @entry = Content.find(params[:id])
    @from_id = params[:from_id]
    unless current_fb_user.nil?
      @friends_list = ImpactCounter.download.with_user(current_fb_user).for_content(@entry) if @entry
    end
    if @entry.is_a?(MusicAlbum)
      if @entry.qualify_for_fb
        render :action => "show_music_album"
      else
        @other_music_albums = @entry.user.contents.music_albums.select{|ma| ma.qualify_for_fb}
        render :action => "music_album_not_available"
      end
    else
      AdminNotifier.async_deliver_alert("Unknown class in facebook/content/show: #{@entry.class.name.to_s} #{@entry.id}")
      render :text => "entry is not a music album, is a #{@entry.class.name.to_s}"
    end
  end

  def publish
    @entry = Content.find(params[:id])
    if @entry
      Activity.create_for(current_fb_user, current_fb_user, @entry, Activity::ACTIVITIES[:content_published_to_wall][:id], {},
        :skip_emails => true)
    end
    render :action => "show_music_album"
  end

  def bookmark
    @entry = Content.find(params[:id])
    if @entry
      Activity.create_for(current_fb_user, current_fb_user, @entry, Activity::ACTIVITIES[:content_saved_to_my_albums][:id], {},
        :skip_emails => true)
    end
    render :action => "show_music_album"
  end

  def save_as
    @entry = Content.find(params[:id])
    file = s3_url_for_bundles(@entry.bundles)
    if file
      Activity.create_for(current_fb_user, current_fb_user, @entry, Activity::ACTIVITIES[:content_downloaded][:id], {},
        :skip_emails => true)
      render :text => "#{file}"
    else
      AdminNotifier.async_deliver_alert("Unknown class in facebook/content/save_as: #{@entry.class.name.to_s} #{@entry.id}")
      render :text => "entry does not have anything downloadable attached, is a #{@entry.class.name.to_s}"
    end
  end

  def increment_invite_counter
    if params[:fb_referrer_id] && !current_fb_user.nil?
      
      content  = Content.find_by_id(params[:id])
      referrer = Facebook::User.find_by_fb_user(params[:fb_referrer_id])
      
      unless referrer.nil? || referrer.id.eql?(current_fb_user.id) || content.nil?
        what = {:user_id => referrer.id , 
                :to_user_id => current_fb_user.id,
                :counter_kind_id => ImpactCounter::COUNTER_KINDS[:invite],
                :content_id => content.id,
                :referral_type =>params[:fb_referral_type]
                }
        impact = ImpactCounter.find(:first, :conditions => what) || ImpactCounter.new(what)
        impact.total = impact.total.next
        impact.save!
        session[:fb_invite_counter_id] = impact.id
      end
    end
  end
  
  def increment_download_counter
    if session[:fb_invite_counter_id] && !current_fb_user.nil?

      invite_counter = ImpactCounter.find_by_id(session[:fb_invite_counter_id])

      if invite_counter and invite_counter.content_id.eql?(@entry.id)
        referrer = User.find_by_id(invite_counter.user_id)
        what = {:user_id => referrer.id , 
                :to_user_id => current_fb_user.id,
                :counter_kind_id => ImpactCounter::COUNTER_KINDS[:download],
                :content_id => @entry.id
                }
        impact = ImpactCounter.find(:first, :conditions => what) || ImpactCounter.new(what)
        impact.total = impact.total.next
        impact.save!
        KarmaPoint.create!(
                  :content      => @entry,
                  :referred     => current_fb_user,
                  :referrer     => referrer,
                  :referral_url => referral_url(referrer, :referral_type => invite_counter.referral_type),
                  :action       => 'download')

      end
    end
  end

  def s3_url_for_bundles(bundles)
    if bundles.is_a?(Bundle)
      bundles.s3_url
    elsif bundles.is_a?(Array)
      bundles.first.s3_url
    end
  end

end