=begin #(fold)
++
Author:: Artem Vasiliev (mailto:abublic@gmail.com)
Copyright:: Copyright 2008 Artem Vasiliev

Redistribution and/or modification of this code is 
governed by the BSD license.

--
=end #(end)

require 'English'
require 'tempfile'

module SystemUtils
  def log_msg(msg, options)
    puts msg if options[:puts]
    log.info msg if options[:log]
  end

  def run_cmd(cmd, options = {})
    options = {:puts => true, :msg => 'doing something', :cmd_label => cmd, :fail_on_error => true}.merge(options)
    message = options[:msg]

    log_msg "#{message} with '#{options[:cmd_label]}'..", options unless message.nil?
    if options[:async]
      exec(cmd)
      return true
    end
    err_file = Tempfile.new('err', 'log')
    err_file.close
    err_file = err_file.path
    output = %x{#{cmd} 2>#{err_file}}
    errout = File.read(err_file).chomp
    File.delete err_file
    code = $CHILD_STATUS
    success = (code == 0)
    if !success && options[:fail_on_error]
      raise "#{options[:cmd_label]} failed with exit code #{code}. Errors: #{errout}."
    else
      if success
        log_msg "#{options[:cmd_label]} succeeded", options
      else
        log_msg "#{options[:cmd_label]} failed with exit code #{code} (ignoring). Errors: #{errout}.", options
      end
      {:success => success, :output => output, :errout => errout}
    end
  end

  def run_external_rake_task(rake_task, options = {})
    run_cmd "ruby -e \"require 'rubygems' rescue nil; require 'rake'; Rake.application.options.trace = true; " +
        "Rake.application.run\" #{rake_task}", {:cmd_label => "rake #{rake_task}"}.merge(options)
  end

  def current_env
    ENV['RAILS_ENV'] || 'development'
  end

  def with_db_params(environment)
    all_db_params = YAML.load_file('config/database.yml')
    db_params = all_db_params[environment]
    raise "unknown environment '#{environment}'" if db_params.nil?
    return nil if !db_params
    psw = db_params['password']
    psw = "-p#{psw}" if (!psw.nil? and !psw.empty?)
    database = db_params['database']
    yield(db_params, database, psw)
  end

  def get_pid_from_file
    File.read(PID_NUMBER_FILE).chomp
  rescue
    nil
  end

  def get_env_pids(env)
    lines = `ps ax|grep ruby|grep #{env}`
    stopwords = %w(rake grep cruise).map {|word| Regexp.new(word)}
    lines = (lines.split("\n").reject {|line| stopwords.any? {|stopword| line =~ stopword}})
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

  def execute_commands(commands, opts = {})
    commands = [commands] if !commands.is_a?(Array)
    msg_prefix = opts[:msg] ? "#{opts[:msg]} - " : ''
    for i in 0..commands.length - 1
      step_msg = msg_prefix + "step #{i + 1} of #{commands.size}" if commands.size > 0
      command = commands[i]
      run_cmd command[:cmd], :msg => step_msg, :cmd_label => command[:label] if command[:cmd]
      run_external_rake_task command[:rake_cmd], :msg => step_msg if command[:rake_cmd]
    end
  end

  def send_lines_to(cmd, lines)
    require (PLATFORM =~ /win32/ ? 'win32/open3' : 'open3')
    
    puts "firing #{cmd}"
    inp, out, err = Open3.popen3(cmd)
    lines.each { |line| inp.puts(line) }
    inp.close                                    # Close is necessary!
    
    output = out.readlines.join('')              # Read from its stdout
    errout = err.readlines.join('')              # Also read from its stderr    
    puts "ok #{cmd} is finished"
    [output, errout]
  end

  def kill_by_pid(pid, opts)
    run_cmd "#{opts[:stop]} #{pid}", :msg => "stopping process #{pid}", :fail_on_error => false
  end

  def kill_by_pid_file(opts)
    pid = get_pid_from_file

    if pid
      kill_by_pid pid, opts
    else
      puts "#{PID_NUMBER_FILE} file not found, will not try to stop the server"
    end
  end

  def kill_by_env(env, opts = {})
    opts = {:stop => 'kill'}.merge(opts)
    pids = get_env_pids env
    puts "processes of #{env} environment not found, nothing to stop" if pids.empty?
    pids.each {|pid| kill_by_pid pid, opts}
  end

  def memory_consumed
    pid = $PID
    pmap_out = run_cmd("pmap -d #{pid}", :fail_on_error => false, :log => true)
    pmap_out[:output].match /mapped: (\d+)K/
    res = $1.to_i
    log.info "memory_consumed by pid #{pid}: #{res} kilos"
    log.warn "hm, so little? bullshit!" if res == 0
    res
  end
  
end