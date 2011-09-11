class Admin::BulkMessageController < Admin::BaseController

  def index
    @all_langs = ['en', 'ru']
    return unless request.post?
    
    # Just basic checks to ensure fields were entered in all languages (don't want to send blank message to half users)
    if params[:en].blank? || params[:en][:subject].blank? || params[:ru][:subject].blank?
      flash[:warning] = "Subject must be entered for all languages".t
      return
    elsif params[:en][:body].blank? || params[:ru][:body].blank?
      flash[:warning] = "Body must be entered for all languages".t
      return
    end
    
    
    # Split users (not projects) up into desired language
    by_language = {}
    User.active.find(:all, :conditions => {:type => [BasicUser.name, AdvancedUser.name]}, :include => :preference).each do |user|
      locale = (user.preference && !user.preference.email_locale.blank?) ? user.preference.email_locale : 'en'
      by_language[locale] = [] if by_language[locale].nil?
      by_language[locale] << user
    end
    
    # For each language, send a message BCCed to all users with that language preference. Skip and report if unknown lang
    extra_langs = []
    by_language.each do |lang, users|
      unless @all_langs.include?(lang)
        extra_langs << lang
        next
      end
      
      subject = params[lang][:subject]
      body    = params[lang][:body]
            
      emails_as_string = users.collect{|u| u.email}.join(', ')
      UserNotifier.enq_deliver_admin_broadcast(lang, emails_as_string, subject, body)
    end
    
    # Report to user
    if extra_langs.empty?
      flash[:success] = "Successfully broadcast message to all users".t
    else
      flash[:warning] = "Sent message to all known languages. Unknown langs found (and skipped)".t + ": #{extra_langs.to_sentence}"
    end
  end

end
