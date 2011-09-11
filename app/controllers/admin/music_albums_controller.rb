module Admin

  class MusicAlbumsController < BaseController

    verify :method => :post, :only => [:make_ma], :redirect_to => {:action => :index}

    def index
      redirect_to :action => :choose_fwd
    end

    def fwd_chosen
      id = params[:fwd_id]
      @album = Content.find_by_id(id)
      unless @album
        flash[:error] = "There's no content with id '{{id}}'" / id
        redirect_to :action => :choose_fwd and return
      end
      allowed_from = [Album, FolderWithDownloadables]
      unless allowed_from.include?(@album.class)
        flash[:error] = "Content '{{id}}' is {{real_type}}, not {{expected_type}}" /
                [id, @album.class.name, allowed_from.map(&:name).join(" #{'or'.t} ")]
        redirect_to :action => :choose_fwd and return
      end
    end

    def make_ma
      @album = Content.find(params[:fwd_id])
      Content.transaction do
        @album.donation_setting_object.circle_to_invite_to = nil
        @album.donation_setting_object.save!
        from_class = @album.class.name
        to_class = 'MusicAlbum'
        @album.update_attribute :type, to_class
        [[FeaturedItem, 'item_type', 'item_id'], [Comment, 'commentable_type', 'commentable_id'],
         [Favorite, 'favorable_type', 'favorable_id'], [Moderation::Event, 'reportable_type', 'reportable_id'],
         [SmsPayload, 'payment_for_type', 'payment_for_id']].each do |klass, type_field, id_field|
          klass.update_all ['%s = ?' % type_field, to_class], ['%s = ? and %s = ?' % [id_field, type_field], @album.id, from_class]
        end

        [Activity, ContentStat, Stat].each do |klass|
          klass.update_all ['content_type = ?', to_class], ['content_id = ? and content_type = ?', @album.id, from_class]
        end
      end

      flash[:success] = "Folder '{{name}}' was successfully converted to Music Album" / @album.title
      redirect_to content_url(@album)
    rescue => e
      just_notify(e)
      flash[:error] = "Failed to convert '{{id}}' to MA: {{error}}. No changes happened." / [params[:fwd_id], e]
      redirect_to :back
    end

  end
end