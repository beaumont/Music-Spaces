module ProfileHelper
  require "erb"
  
  # TODO add proc
  def avatar_filename(avatar)
    (avatar.thumb(:tiny) || avatar).public_filename
  rescue
    "/images/missing_image.png"
  end
  
  def profile_question(question)
     kf_simple(question.answer)
  end
  
  def profile_tags(user, tags)
    tags.collect{ |tag| link_to(tag, user_url_for(user, :action => 'tags', :tag => tag)) }.join(', ')
  end
  
  def profile_question_input(question, optional = true, label = nil)
    render :partial => '/layouts/shared/profile_question_input', :locals => { :question => question, :optional => optional, :label => label}
  end
  

end
