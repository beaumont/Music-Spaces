module TpsHelper
  def goodies_left_caption(goodie, options = {})
    infinity = 10
    if goodie.left.nil?
      'available'.t
    elsif goodie.left > 0
      if goodie.left == 1
        'only one ((goodie)) left'.t
      elsif goodie.left >= infinity
        'available'.t
      else
        '{{count}} ((goodies)) available' / goodie.left
      end
    else
      'all ((goodies)) gone!'.t
    end
  end

  def tps_ends_in_caption(hat)
    return 'Not Started'.t if hat.end_date.blank? && hat.started_at.blank?
    return 'Never ends'.t if hat.duration == 0
    count = (hat.end_date || (hat.started_at + hat.duration.days)) - Date.current
    count > 0 ? 'Ends in {{count}} days' / count : 'Ends today'.t
  end

  def link_to_tps_payments_page(hat)
    link_to 'Received Payments'.t, :controller => 'tps',
            :action => 'payments', :id => hat.id
  end

  def link_to_tps_participants_page(hat)
    link_to "Participants' Info".t, :controller => 'tps',
            :action => 'participants', :id => hat.id
  end

  def link_to_goodies_payments_page(project)
    link_to 'Received Payments'.t, :controller => 'goodies',
            :action => 'payments'
  end

  def link_to_goodies_participants_page(project)
    link_to "Participants' Info".t, :controller => 'goodies',
            :action => 'participants'
  end

  def tps_info_not_needed_label
    '<i>' + 'not required'.t + '</i>'
  end

  def tps_participant_info_field(participant, field, needed)
    result = participant.send(field)
    return tps_info_not_needed_label unless result || needed
    h(result)
  end

  def tps_participant_info_document_field(participant, field)
    tps_participant_info_field(participant, field, participant.document_missing?)
  end

  def tps_participant_info_address_field(participant, field)
    tps_participant_info_field(participant, field, participant.address_missing?)
  end

  def tps_setup_part_info(action)
    {
      'intro' => ['((tps setup page)) Introduction'.t ],
      'for_profile' => ['((tps setup page)) Summary'.t ],
      'for_page' => ['((tps setup page)) Details'.t],
      'for_goodies_page' => ['((tps setup page)) Goodies'.t],
      'overview' => ['Overview'.t],
      'last_step' => ['Campaign Launch'.t],
    }[action]
  end

  def maybe_link_to_tps_setup_page(action, options = {})
    title, caption = tps_setup_part_info(action)
    caption = title if options[:title]
    return unless caption
    #no_links = true if @content.new?
    if options[:current] == action
      '<span class="current">' + caption + '</span>'
    else
      link_to(caption, :action => action, :id => @content)
    end
  end
end
