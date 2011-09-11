class Admin::FaqController < Admin::BaseController
  in_place_edit_for :faq, :question
  in_place_edit_for :faq, :question_ru
  in_place_edit_for :faq, :answer
  in_place_edit_for :faq, :answer_ru
  
  def index
    @faqs = Faq.find(:all)
  end
  
  def destroy
    if request.post?
      if Faq.find(params[:id]).destroy
        flash[:success] = "FAQ destroyed"
      else flash[:warning] = "Error deleting FAQ"
      end
    else flash[:warning] = "That method must be accessed via POST"
    end
    redirect_to :action => 'index'
  end

  def create
    if request.post?
      f = Faq.new(params[:faq])
      if f.save
        flash[:success] = "FAQ created"
      else flash[:warning] = "Error adding FAQ"
      end
    else flash[:warning] = "That method must be accessed via POST"
    end
    redirect_to :action => 'index'
  end

  # in_place_editor helpers
  [:question, :answer].each do |field|
    define_method "unformatted_#{field}" do
      render_unformatted_field(Faq.find(params[:id]), field)
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
