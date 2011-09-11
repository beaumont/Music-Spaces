class Admin::MessagesController < Admin::BaseController
  in_place_edit_for :admin_flash, :message
  in_place_edit_for :admin_flash, :message_ru
  
  def index
    @show_date_select = true        
    @messages = AdminFlash.find(:all)
  end

  def edit
    @show_date_select = true
    @admin_flash = AdminFlash.find(params[:id])
    if request.post?
      if @admin_flash.update_attributes(params[:admin_flash])
        AdminFlash.expire_cache! if @admin_flash == AdminFlash.random_message
        flash[:success] = "Updated message"
        redirect_to :action => 'index'
      else
        flash[:warning] = "Error updating message"
      end
    end
  end
  
  def destroy
    if request.post?
      if AdminFlash.find(params[:id]).destroy
        flash[:success] = "Message destroyed"
      else flash[:warning] = "Error deleting message"
      end
    else flash[:warning] = "That method must be accessed via POST"
    end
    redirect_to :action => 'index'
  end

  def toggle
    if request.post?
      f = AdminFlash.find_by_id(params[:id])
      
      # If existing message is currently set to be shown, and you're hiding it, clear the cache so new message can be displayed. Clear later so it's not just reset when a page request comes in before this method finishes
      needs_clearing = f && f.shown && AdminFlash.random_message == f
      if f && f.update_attribute(:shown, !f.shown?)
        flash[:success] = "Toggled message #{f.id} status"
      else flash[:warning] = "Error editing message"
      end
      AdminFlash.expire_cache! if needs_clearing

    else flash[:warning] = "That method must be accessed via POST"
    end
    redirect_to :action => 'index'
  end

  def create
    if request.post?
      f = AdminFlash.new(params[:admin_flash])
      if f.save
        flash[:success] = "Message created"
      else flash[:warning] = "Error adding message"
      end
    else flash[:warning] = "That method must be accessed via POST"
    end
    redirect_to :action => 'index'
  end
  
  def clear_messages_cache
    AdminFlash.expire_cache!
    flash[:success] = 'Message cache cleared'.t
    redirect_to :action => :index
  end

  def unformatted_message
    render_unformatted_field(AdminFlash.find(params[:id]), :message)
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
