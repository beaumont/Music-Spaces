class BaseWorker < BackgrounDRb::MetaWorker
  protected
  # send an email with the exception info
  def capture_exception(method_name, options = {})
    options.reverse_merge! :log_hello => true
    logger.info("[DRB #{Time.now.strftime('%m/%d/%Y at %H:%M:%S')}] #{method_name}") if options[:log_hello]
    begin
      yield        
      # we don't care about these exceptions
      logger.info("[DRB #{Time.now.strftime('%m/%d/%Y at %H:%M:%S')}] #{method_name} finished") if options[:log_hello]
      true
    rescue LiveJournal::Request::ProtocolException,  Timeout::Error, URI::InvalidURIError
      logger.info("[DRB #{Time.now.strftime('%m/%d/%Y at %H:%M:%S')}] #{method_name} failed with skipped excepton: #{e.inspect}") if options[:log_hello]
      true
    rescue Exception => e
      msg = "[DRB] Exception happened executing %s: %s" % [method_name, e.inspect]
      logger.error msg
      if options[:mail]
        msg += ("\n Args: %s" % options[:args].inspect) if options[:args]
        AdminNotifier.async_deliver_admin_alert(msg)
      end
      false
    end
  end
end

