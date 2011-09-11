class StatsWorker < BackgrounDRb::MetaWorker
  set_worker_name :stats_worker
  
  def create(args = nil)
    logger.info "[StatsWorker] Create called" unless RAILS_ENV == 'production'
    # this method is called when worker is loaded for the first time
  end
    
  # Mark stats async
  def mark_stat(params)
    # logger.info "[MARKING STAT] #{params.inspect}" unless RAILS_ENV == 'production'
    kind, options = params
    options[:content] = options.delete(:klass).find_by_id(options.delete(:id))
    ContentStat.send(kind, options)
  rescue Exception => e
    logger.info e.class.name
    logger.info e.message
  end
  
end
