#patch from https://rails.lighthouseapp.com/projects/8994/tickets/1552-memory-problem-with-configlog_level-warn

module ActiveSupport
  class BufferedLogger
    def flush
      count = nil
      @guard.synchronize do
        count = @log.write(buffer.join) unless buffer.empty?
        clear_buffer
      end
      count
    end
  end
end
