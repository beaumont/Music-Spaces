# We want to allow guests to view things, but we don't want to find every place in the code
# where we call current_actor.is_a_follower_of? or similar
class Guest
  # 0 is not safe as its mysql default, relying on method_missing is not safe either cause then its random
  ID = -1
  
  def id
    ID
  end
  
  def login
    'Guest'
  end
  def display_name
    'Guest User'
  end
  
  def actor
    return self
  end
  
  def profile
    @profile ||= GuestProfile.new
  end
  
  def self.base_class
    Object
  end
  
  def guest?
    true
  end
  
  def project?
    false
  end
  
  def is_self_or_owner?(*others)
    others.any?{|other| self == other}
  end
  
  def is_view_permitted?(*args)
    false
  end
  
  def restriction_level
    0
  end
  
  def is_a_follower_of?(*args)
    false
  end

  def is_a_follower_of(*args)
    []
  end
  
  def followers_count(*args)
    []
  end
  
  def followed_by_count
    []
  end
  
  def in_role?(*args)
    false
  end
  
  def welcome_content_languages
    I18n.locale == 'en' ? 'en' : :all
  end

  def method_missing(*args)
    return nil
  end

  def last_pending_invitation_of(invited_user)
    nil
  end

  def last_pending_invitation_request_to(desired_user)
    nil
  end

end

class GuestProfile
  def id
    -1
  end
  
  def is_view_permitted?(*args)
    false
  end
  
  def restriction_level
    0
  end
  
  def contextual_tag_list(*args)
    []
  end
  def method_missing(*args)
    return nil
  end
end