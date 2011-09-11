class ModerateController < ApplicationController
  layout 'moderation'
  before_filter :admin_required
  before_filter :grab_relevant_item, :only => [:report, :block, :restore]
  
  def reports
    if params[:show] == 'users-reported' || params[:show] == 'content-reported' 
      @items = Moderation::Report.items( params[:show] == 'users-reported' ? :user : :content).sort_by(&:created_at)
    elsif params[:show] == 'users-blocked' || params[:show] == 'content-blocked' 
      @items = Moderation::Block.items( params[:show] == 'users-blocked' ? :user : :content).select{|x| x.blocked?}.sort_by(&:created_at)
    elsif params[:show] == 'users-all'
      uids = (params[:users].to_s).split(',').map{|x| x.to_i}
      all_items = Moderation::Event.items.collect{|x| x.is_a?(User) ? x : x.try(:user)}.compact
      @items = uids.empty? ? all_items.uniq : all_items.select{|u| uids.include?(u.id)}.uniq
    else 
      @events = Moderation::Event.order('created_at DESC')
    end
  end
  
  def user_search
    matches = User.find_by_login(params[:user]).to_a.collect{|x| x.id}
    if matches.empty?
      flash[:warning] = 'No matching users found - showing all users'.t
    end
    redirect_to :action => 'reports', :show => 'users-all', :users => matches.join(',')
  end
  
  def simple_reports
    @reports = Moderation::Report.find(:all, :order => 'created_at desc')
    @blocks = Moderation::Block.find(:all, :order => 'created_at desc')
    @restores = Moderation::Restore.find(:all, :order => 'created_at desc')
  end
  
  
  # Users can submit content reports. Login required for now, can implement captchas later.
  def report
    render(:nothing => true) and return unless request.post? && params[:report]
    
    if params[:report][:reason].blank? && params[:report][:message].blank?
      render(:update) do |page|
        page['report-errors'].replace_html '<br/>' + "Select reason for report".t
        page['report-wrapper'].visual_effect :highlight
      end        
      return
    end
    
    rpt = Moderation::Report.new(:reason => params[:report][:reason], :message => params[:report][:message], :user_id => current_actor.id, :reportable_type => @entry.class.name.to_s, :reportable_id => @entry.id)
    if rpt.save
      render(:update) do |page|
        page['report-wrapper'].replace_html "Thanks, your report's been submitted".t
        page['report-wrapper'].visual_effect :highlight
      end
    else
      render(:update) do |page|
        page['report-errors'].replace_html "Unable to save report!".t
        page['report-wrapper'].visual_effect :highlight
      end
    end
  end
  
  def block
    render(:nothing => true) and return unless request.post? && params[:block]
    
    if params[:block][:reason].blank? && params[:block][:message].blank?
      render(:update) do |page|
        page['block-errors'].replace_html '<br/>' + "Select reason for block".t
        page['block-wrapper'].visual_effect :highlight
      end        
      return
    end
    
    block = Moderation::Block.new(:reason => params[:block][:reason], :message => params[:block][:message], :user_id => current_actor.id, :reportable_type => @entry.class.name.to_s, :reportable_id => @entry.id)
    if block.save
      render(:update) do |page|
        page['block-wrapper'].replace_html "Item has been blocked".t
        page['block-wrapper'].visual_effect :highlight
      end
    else
      render(:update) do |page|
        page['block-errors'].replace_html "Unable to save block!".t
        page['block-wrapper'].visual_effect :highlight
      end
    end
  end
  
  def restore
    render(:nothing => true) and return unless request.post? && params[:restore]
    
    restoration = Moderation::Restore.new(:message => params[:restore][:message], :user_id => current_actor.id, :reportable_type => @entry.class.name.to_s, :reportable_id => @entry.id)
    if restoration.save
      render(:update) do |page|
        page['block-wrapper'].replace_html "Item has been restored".t
        page['block-wrapper'].visual_effect :highlight
      end
    else
      render(:update) do |page|
        page['block-errors'].replace_html "Unable to restore item!".t
        page['block-wrapper'].visual_effect :highlight
      end
    end
  end
  
  protected
  
  def authorized?(user = nil)
    user ||= current_actor
    permitted?(user, :moderate) || params[:action] == 'report'
  end
  
  def grab_relevant_item
    @entry = if Content.name == params[:type].to_s then params[:type].constantize.find(params[:id]) # NOT Content.active.find -- we want inactive bits too
    end
    return Kroogi::NotFound unless @entry
  end
  
end
