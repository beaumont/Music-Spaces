class Admin::TranslateController < Admin::BaseController
  
  def index
    condition_str = "type = '#{ViewTranslation.name}' AND language_id = #{Locale.language.id}"
    @max_pluralizations = (I18n.locale == 'en' ? 2 : 3)

    if params[:term] =~ /\*\*.*/
      condition_str += " AND (tr_origin LIKE '%"+params[:term].gsub("**","")+"%')"
    elsif !params[:term].blank?
      term = params[:term] # Alex wants to have to enter % by hand for sql like search
      condition_str += " AND (text like #{User.quote_value(term)} or tr_key like #{User.quote_value(term)})"
    end

    params[:order] ||= 'date'
    order_str = 'if(tr_origin is null, 1, 0), if(text is null, 0, 1), plurals desc, updated_at DESC, tr_key ASC'

    @view_translations = ViewTranslation.paginate :conditions => condition_str, :group => :tr_key,
                      :select => ViewTranslation.column_names.join(', ') +', COUNT(globalize_translations.pluralization_index) AS plurals',
                      :order => order_str, :per_page => 250, :page => params[:page]
  end

  def clear_dnrs
    removed = ViewTranslation.delete_all "text = '' OR text is null"
    removed += ViewTranslation.delete_all "text = 'dnr'"
    removed += ViewTranslation.delete_all ["obsolete=?", true]
    flash[:success] = "Removed {{count}} obsolete translations records (and those marked 'dnr'). Note that pluralization could make this number bigger than actual DNR translation strings." / removed 
    redirect_to :action => 'index'
  end
  
  def translation_text
    @translation = ViewTranslation.find(params[:id])
    render :text => @translation.text || ""
  end
  
  def set_translation_text
    @translation = ViewTranslation.find(params[:id])
    previous = @translation.text
    @translation.text = params[:value]
    @translation.text = previous unless @translation.save
    render :partial => "/shared/in_place_value", :object => @translation.text
  end
  
  def translation_key
    @translation = ViewTranslation.find(params[:id])
    render :text => @translation.tr_key || ""
  end

  def set_translation_key    
    all_plurals_with_key = ViewTranslation.find(:all, :conditions => 
        ['language_id=? and tr_key=?',
        Locale.language.id, params[:old]], :order => 'pluralization_index')
    
    error = false
    new = params[:value]
    all_plurals_with_key.each do |tran|
      tran.tr_key = new
      error = true unless tran.save
    end
    unless error
      render :text => all_plurals_with_key[0].tr_key.to_s #it can be different than passed value - e.g. tags are eaten
    else
      render :text => '<span style="color: red;">Error saving the key! Please re-fresh the page.</span>'
    end
  end

  def scan_code
    @report = []
    import_strings
  end

  def grab_dump_page
    if flash[:dump_error]
      @error = flash[:dump_error]
      return
    end
    @easy_mode = (RAILS_ENV == 'development')
    if @easy_mode
      @report = ""
      @file_name, @records_num = dump_to_file(:svn => true)
      @error = @report unless @file_name 
      @file_name = File.join(translation_base, @file_name) if @file_name
    end
  end

  def grab_dump
    @report = ""
    file_name, records = dump_to_file(:svn => false)
    if file_name
      send_file File.join(translation_base, file_name)
    else
      flash[:dump_error] = @report 
      redirect_to :action => :grab_dump_page 
    end
  end

  def apply_translations
    I18n.backend.instance_eval {load_globalize_translations(:clean_existing => true)}
    redirect_to :action => 'index'
  end
  
  private
  require 'translation_tasks_mixin'
  include TranslationTasksMixin

end