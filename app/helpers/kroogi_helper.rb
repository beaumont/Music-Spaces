module KroogiHelper

  TEASERS = {
    'CollectionProject' => {
      :interested => lambda {|user| 'Members receive updates on their home page when we post anything new.'.t}
    },
    'BasicUser' => {
      :family => lambda {|user| 'Members of this circle receive updates from {{user}}, have access to all content marked "Friends" and have exclusive access to content marked "Family". Invitation to this circle cannot be requested.' / user.display_name},
      :backstage => lambda {|user|
        ('In addition to receiving updates from {{user}}, members of this circle have access to special content marked "Friends".' / user.display_name) + " " +
        ('If you receive and accept the invitation to this circle, {{user}} will also be automatically added to your "Friends" circle.' / user.display_name)
      },
      :interested => lambda {|user| "Once you join this circle, you will start receiving updates from {{user}}." / user.display_name}
    },
    'AdvancedUser' => {
      :family => lambda {|user| 'Members of this circle receive updates from {{user}}, have access to all content marked "Friends" and have exclusive access to content marked "Family". Invitation to this circle cannot be requested.' / user.display_name},
      :backstage => lambda {|user|
        ('In addition to receiving updates from {{user}}, members of this circle have access to special content marked "Friends".' / user.display_name) + " " +
        ('If you receive and accept the invitation to this circle, {{user}} will also be automatically added to your "Friends" circle.' / user.display_name)
      },
      :interested => lambda {|user| 'Once you join this circle, you will start receiving updates from {{user}}.' / user.display_name}
    },
    'Project' => {
      :family => lambda {|user| "Our project participants.".t},
      :fanclub => lambda {|user| "Loyal fans.".t},
      :interested => lambda {|user| "People following us.".t}
    }
  }

  TITLES_FOR_REMOVE_LINKS = {
    'CollectionProject' => {
      :interested => lambda {"Remove from this circle".t},
      :founders => lambda{"Move to Interested".t}
    },
    'BasicUser' => {
      :interested => lambda {"Remove from this circle".t},
      :backstage => lambda {'Move to Interested'.t},
      :family => lambda {'Move to Friends'.t}
    },
    'AdvancedUser' => {
      :interested => lambda {"Remove from this circle".t},
      :backstage => lambda {'Move to Interested'.t},
      :family => lambda {'Move to Friends'.t}
    },
    'Project' => {
      :interested => lambda {"Remove from this circle".t},
      :family => lambda {|user| "Move to Fan Club".t},
      :fanclub => lambda {|user| "Move to Audience".t},
      :founders => lambda {|user| "Move to Studio".t}
    }
  }

  def teaser(user, kroog)
    for_user = TEASERS[user.class.to_s]
    return kroog_teaser(kroog) if for_user.blank?
    for_user[kroog.relationshiptype_name].blank? ? kroog_teaser(kroog) : for_user[kroog.relationshiptype_name].call(user)
  end

  def kroog_teaser(kroog)
    kroog.teaser.blank? ? render(:partial => 'noaccess') : kf_simple(kroog.teaser)
  end

  def remove_link_for(user, follower, kroog = nil, remove_me = false)
    return unless remove_me || current_actor.is_self_or_owner?(user)
    kroog ||= user.find_circle_with(follower)

    type = kroog.relationshiptype_name

    return "" if type == :interested && !remove_me

    return "" unless proc = TITLES_FOR_REMOVE_LINKS[user.class.to_s][type]
    
    content_tag(:div, link_to(proc.call,
      {:controller => '/kroogi', :action => (remove_me ? 'remove_me' : 'remove'), :id => (remove_me ? user.id : follower.id)},
      {:method => :post, :confirm => remove_me ? 'Are you sure you want to leave?'.t : 'Are you sure you want to do this?'.t}), :class => "i_delete")
  end

end