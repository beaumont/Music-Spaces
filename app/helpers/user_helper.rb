module UserHelper
  def collection_item_weight(project)
    if project.collection?
      '%d projects' / [project.featured_album.album_contents_items.count]
    else
      '%d followers' / [project.followers_count_sum || 0]
    end
  end

  @@all_projects = [['ЕВГЕНИЙ ГРИШКОВЕЦ', 'EVGENIY GRISHKOVETS', 'e-grishkovets'],
    ['БОРИС ГРЕБЕНЩИКОВ', 'BORIS GREBENSHIKOV', 'bg'],
    ['АЛЕКСЕЙ БОРИСОВ', 'ALEXEI BORISOV', 'borisov'],
    ['ЗАХАР МАЙ', 'ZAHAR MAY', 'zaxarborisych'],
    ['ИВАН МАКСИМОВ', 'IVAN MAXIMOV', 'ivanmaximov'],
    ['ХИХУС', 'XIXYC', 'xixyc'],
    ['ИННА ЖЕЛАННАЯ', 'INNA ZHELANNAYA', 'voplostchenie-fest'],
    ['АНЖЕЛА МАНУКЯН', 'ANZHELA MANUKIAN', 'voplostchenie-fest'],
    ['ПЕЛАГЕЯ', 'PELAGEYA', 'voplostchenie-fest'],
    ['НАМГАР', 'NAMGAR', 'voplostchenie-fest'],
    ['РАДА И ТЕРНОВНИК', 'RADA I TERNOVNIK', 'rada-i-ternovnik', :band],
    ['УМКА И БРОНЕВИЧОК', 'UMKA I BRONEVICHOK', 'bronevik', :band],
    ['TEQUILAJAZZZ', nil, 'tequilajazzz', :band, {:ru => 'ТЕКИЛАДЖАЗ'}],
    ['ВОЛГА', 'VOLGA', 'volga', :band],
    ['АКВАРИУМ', 'AQUARIUM', 'aquarium', :band],
    ['MARKSCHEIDER KUNST', nil, 'mkunst', :band, {:ru => 'МАРКШЕЙДЕР КУНСТ'}],
    ['SIMBA VIBRATION', nil, 'simbavibration', :band, {:ru => 'СИМБА ВИБРЭЙШН'}],
    ['НОЧНОЙ ПРОСПЕКТ', 'NOCHNOY PROSPEKT', 'notchnoi-prospekt', :band],
    ['КОЛИБРИ', 'KOLIBRI', 'kolibri', :band]]

  def get_project_info_map(project_info_array, lang)
    name_ru, name_en, login, band_flag, sort_key = *project_info_array
    name = (lang == :ru ? name_ru : name_en)
    name ||= name_ru
    {:name => name, :login => login, :band_flag => band_flag,
      :sort_key => sort_key}
  end
  
  def project_sort_key(project_info, lang)
    return project_info[:sort_key][lang] if project_info[:sort_key] && project_info[:sort_key][lang]
    return project_info[:name] if project_info[:band_flag]
    return project_info[:name].split.last #we sort artists by last name
  end

  def maybe_selected_class(options)
    controller_name = options[:controller].gsub("/", "") if options[:controller]
    action = options[:action]
    selected = (action == controller.action_name)
    if controller_name
      selected &&= (controller_name == controller.controller_name)
    end
    selected ? 'selected' : nil
  end

  def maybe_selected_user_link(caption, user, options = {})
    klass = maybe_selected_class(options)
    if klass
      '<span class="%s">%s</span>' % [klass, caption]
    else
      link_to caption, user_url_for(user, options)
    end
  end

  def should_see_founders_link?(user, options = {})
    if options.delete(:me_only_icon)
      return !user.preference.show_founders_tab? && current_actor.is_self_or_owner?(user)
    end
    user.preference.show_founders_tab? || current_actor.is_self_or_owner?(user) || current_user.admin?
  end

  def collection_breadcrumbs(user)
    chain = user.collections_ancestory_chain.map {|id| User.find(id)}
    sep = "&nbsp;&nbsp;&gt;&nbsp;&nbsp;"
    result = chain.map {|u| user_link(u, :limit => 20, :use_display_name => true)}
    result[0] = '<span class="main_header_title">' + result[0] + '</span>'
    result.join(sep)
  end
  
end
