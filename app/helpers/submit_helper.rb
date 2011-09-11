module SubmitHelper

  def contest_edit_part_info(part)
    {
            'header' => ['edit', 'Edit Contest Header'.t],
            'change_image' => ['change_contest_image', 'Change Contest Image'.t],
            'add_originals' => ['add_contest_originals', 'Add Originals'.t],
            'add_track' => ['add_track_to_contest', 'Upload Track'.t, true],
            'edit_track_properties' => ['edit_contest_track_properties', 'Edit Track Properties'.t, true],
    }[part]
  end

  def maybe_link_to_contest_edit_page(part, options = {})
    action, caption = contest_edit_part_info(part)
    current_info = contest_edit_part_info(options[:current])
    no_links = current_info[2] if current_info
    no_links = true if @content.new?
    if options[:current] == part
      '<span class="current">' + caption + '</span>'
    else
      no_links ? caption : link_to(caption, :action => action, :id => @content)
    end
  end

  def contest_edit_part_path(contest, part)
    {:action => contest_edit_part_info(part)[0], :id => contest}
  end
  
end
