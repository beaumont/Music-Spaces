module AntiDdos

  include SiteActivityLoggerForControllers

  def initialize
    Rails.cache.write('search_visits', {:visits => 0, :grain_ends_at => Time.current}) if Rails.cache.read('search_visits').blank?
  end

  def count_requests
    return unless current_user.is_a?(Guest)
    data = Rails.cache.read('search_visits')

    if data[:grain_ends_at] + APP_CONFIG.search_for_guests[:interval] < Time.current
      data = {:visits => 0, :grain_ends_at => Time.current}
    end

    data[:visits] += 1

    Rails.cache.write('search_visits', data)

    render :template => "/shared/many_rpm", :layout => "application" if data[:visits] > APP_CONFIG.search_for_guests[:requests]
  end

end            