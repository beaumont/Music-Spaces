RAILS_HOME = File.expand_path(File.join(File.dirname(__FILE__),".."))
require File.join(RAILS_HOME, 'vendor', 'plugins', 'system_utils', 'lib', 'system_utils')

include SystemUtils

out = run_cmd('svn info')[:output]
out.match(/^Last Changed Rev: (\d+)/)
revision = $1
to_file = "log/production#{revision}.log"
raise "#{to_file} exists!" if File.exists?(to_file)
run_cmd("mv log/production.log #{to_file}", :fail_on_error => false)
run_cmd("mv log/memory_profiler.log log/memory_profiler#{revision}.log" , :fail_on_error => false)
run_cmd("mkdir log/memory_profiler_strings/#{revision}", :fail_on_error => false)
run_cmd("mv log/memory_profiler_strings.log* log/memory_profiler_strings/#{revision}" , :fail_on_error => false)
