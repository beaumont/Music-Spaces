module MaintenanceUtils
  def log_entry_point
    begin
      raise "Hello! I'm %s. Stack trace to my call: " % self.inspect
    rescue => e
      log.debug e.message
      log.debug e.application_backtrace.join("\n  ")
    end    
  end
  
  def log_progress(i, t0, options = {})
    options.reverse_merge!(:description => 'operation', :each => 100)
    if i % options[:each] == 0 || options[:force]
      options[:description] += ' '
      puts("%sdone , this bit in %ss" % [options[:description], Time.now - t0])
      true
    end
  end  

  #usage: e.g. to get pids of backgroundrb worker processes we could use this:
  # get_pids 'ruby', ['mongrel', :inverse], 'load_worker_env'
  def get_pids(*filters)
    grep_cmd = 'egrep'
    filters << [grep_cmd, :inverse]
    cmd = "#{(['ps uax'] + filters.map {|f| f.is_a?(Array) ? '%s -v "%s"' % [grep_cmd, f[0]] : '%s "%s"' % [grep_cmd, f]}).join("|")}"
    puts cmd
    lines = `#{cmd}`
    pids = []
    if lines
      lines.each do |line|
        if line =~ /\d+/
          pid = $&
          puts "pid #{pid}, matched line:\n#{line}"
          pids << pid
        end
      end
    end
    pids
  end

end
