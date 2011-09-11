class Admin::FeaturedItemsController < Admin::BaseController
  in_place_edit_for :featured_item, :editorial
  in_place_edit_for :featured_item, :editorial_ru
  in_place_edit_for :featured_item, :synopsis
  in_place_edit_for :featured_item, :synopsis_ru
  
  def index
    if request.post?
      begin
        if params[:project_id]
          project = User.find(params[:project_id])
          FeaturedItem.feature!(project, params[:project_editorial], params[:project_editorial_ru], params[:project_synopsis], params[:project_synopsis_ru])
        end
      
        if params[:item_id]
          content = Content.active.find(params[:item_id])
          FeaturedItem.feature!(content)
        end
        
        flash[:success] = "Featured items updated" if params[:pid] || params[:iid]
      rescue Exception => e
        flash[:warning] = "Error featuring the specified items: #{e}"
      end
    end
    @projects = FeaturedItem.projects(:all, :convert => false)
    @items =    FeaturedItem.items(:all, :convert => false)
    @albums =   FeaturedItem.download_albums(:all, :convert => false)

    @problems = []
    (@items + @albums).each do |fi|
      item_label = @items.include?(fi) ? 'Item' : 'Album'
      unless fi.item
        # "There's a whole in albums because an item doesn't exist".t
        # "There's a whole in items because an item doesn't exist".t
        s = "There's a whole in #{item_label.downcase}s because an item doesn't exist"
        @problems << s.t
        next
      end

      unless fi.item.public?
        # 'Album %s is not public - it will be a hole at Explore'.t
        # 'Item %s is not public - it will be a hole at Explore'.t
        s = "#{item_label} %s is not public - it will be a hole at Explore" 
        @problems << s / fi.item.id
      end

      if fi.item.is_a?(BasicFolderWithDownloadables) && @items.include?(fi)
        s = "Downloadable album %s is a featured item - it shouldn't be. Please unfeature it and feature as Downloadable Album" / fi.item.id
        @problems << s
      end
      
      if fi.item.is_a?(BasicFolderWithDownloadables) && fi.item.bundles.blank?
        s = "Downloadable Album %s has no attachments - what a shame!" / fi.item.id
        @problems << s
      end
      
    end
  end
  
  def edit
    @item = FeaturedItem.find(params[:id])
    if request.post?
      if @item.update_attribute(:editorial => params[:editorial])
        flash[:success] = "Edit was successful"
        redirect_to :action => 'index'
      else flash[:warning] = 'Error editing'
      end
    end
  end
  
  def unfeature
    if request.post?
      if fi = FeaturedItem.find_by_id(params[:id])
        fi.defeature!
        flash[:success] = "Unfeatured item"
      else flash[:warning] = "Unable to find featured item by that ID"
      end
    else flash[:warning] = "That method only accepts POST requests"
    end
    redirect_to :action => 'index'
  end

  # in_place_editor helpers
  [:synopsis, :editorial].each do |field|
    define_method "unformatted_#{field}" do
      render_unformatted_field(FeaturedItem.find(params[:id]), field)
    end
  end

  protected

    # Force english -- otherwise translations don't work
    def set_locale
      default_locale = 'en-US'
      Locale.set default_locale

      # fix the hostname to represent the reality 
      # todo - move it so its only done once somehow
      APP_CONFIG[:hostname] = user_domain
    end
  
end
