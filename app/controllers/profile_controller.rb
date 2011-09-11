class ProfileController < ApplicationController

    # TODO: OPEN SYSTEM requires slight action here
    before_filter :login_required

    verify :method => :post, :only => [:update_account ]

    before_filter :validate_access
    before_filter :retrieve_profile, :only => [:edit_avatar]
    before_filter :load_projects, :only => [:edit_basic, :edit_avatar, :update_account]
    
    def edit_basic
      @user = @profile.user
    end

    def edit_avatar
      @avatars = @profile.avatars
      @content = Image.new
      @content.user_id = @profile.user_id
      @content.cat_id = Content::CATEGORIES[:avatar][:id]
      @user = @profile.user

      if request.post?
        begin
          # Save titles
          if params[:avatar]
            params[:avatar].each do |pav|
              if a = Image.active.find_by_id_and_user_id(pav[:id].to_i, @profile.user_id)
                a.update_attribute(:title, pav[:title]) unless a.title == pav[:title]
              end
            end
          end
        
          # Delete unwanted
          unless params[:delete].blank?
            params[:delete].each do |del|
              @profile.update_attribute(:avatar_id, nil) if @profile.avatar_id.to_i == del.to_i
              if a = Image.active.find_by_id_and_user_id(del.to_i, @profile.user_id)
                if a.filename.nil?
                  # this is completely wasted
                  Image.delete_all("id = '#{a.id}' OR parent_id = '#{a.id}'")
                else
                  a.cat_id = Content::CATEGORIES[:image][:id]
                  a.save!
                end
              end
            end
          end
                
          # Handle default
          if params[:default] && a = Image.active.find_by_id_and_user_id(params[:default].to_i, @profile.user_id)
            @profile.update_attribute(:avatar_id, a.id)
          end

          flash[:success] = "Avatar changes saved".t
          redirect_to :controller => 'preference', :action => 'show', :id => @content.user.id and return

        rescue Exception => e
          raise e
          flash[:warning] = "Error saving changes: #{e}".t
          redirect_to :controller => 'profile', :action => 'edit_avatar', :id => @profile
        end
      end
    end
    
    def update_account
      @user = @profile.user
      if params[:user]
          params[:user][:display_name] = @profile.user.login if (params[:user][:display_name].blank? and params[:user][:_display_name].blank?)
          unless @profile.user.update_attributes(params[:user])
              flash[:warning] = 'Account update failed'.t
              return render(:action => 'edit_basic')
          end
      end
     
      @profile.attributes = params[:profile]
      @profile.save!
      flash[:success] = 'Details were successfully updated.'.t

      # TODO: Clear caches here
      # expire_action :controller => 'user', :action => "index", :id => @profile.user.id
      # expire_action :controller => 'user', :action => "index", :id => @profile.user.login
      # ...

      redirect_to :controller => 'preference', :action => 'show', :id => @profile.user.id and return
      
    rescue ActiveRecord::RecordInvalid
      load_projects
      render :action => "edit_basic", :id => @profile.id
    end

    def upgrade_account
      if request.post?
        
        begin
          if @profile.user.change_type!(AdvancedUser)
            flash[:success] = 'You now have an Advanced Account'.t
            redirect_to :controller => 'preference', :action => 'show', :id => @profile.user.id and return
          end

          rescue Exception => e
            raise e
            flash[:warning] = "Error Upgrading Account #{e}".t
            redirect_to :controller => 'preference', :action => 'show', :id => @profile.user.id
        end
      end
    end

    private

    def validate_access
        raise ActiveRecord::RecordNotFound if params[:id].blank?
        retrieve_profile
        log.debug "hello"
        raise Kroogi::NotPermitted unless permitted?(@profile.user, :profile_edit)
        log.debug "hello"
    end

    def retrieve_profile
        @profile = Profile.find(params[:id])
        unless @profile.is_view_permitted?
          flash[:warning] = "Unable to view profile"
          redirect_to('/activity/list') and return
        end
    end
end
