RAILS_HOME = File.expand_path(File.join(File.dirname(__FILE__),".."))
require File.join(RAILS_HOME, 'vendor', 'plugins', 'system_utils', 'lib', 'system_utils')

include SystemUtils

s = `ps wuax|grep kroogi_leaktest|grep -v grep`
puts "matched line: \n%s" % s
s.match /(\d+)/
run_cmd "kill #{$1}"
