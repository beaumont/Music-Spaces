=begin #(fold)
++
Author:: Artem Vasiliev (mailto:abublic@gmail.com)
Copyright:: Copyright 2008 Artem Vasiliev

Redistribution and/or modification of this code is 
governed by the BSD license.

--
=end #(end)
class Timed
  def self.log_msg(msg, options)
    options[:stdout] ? puts(msg) : log.debug(msg)    
  end
  
  def self.run(description, options = {})
    options.reverse_merge! :stdout => true 
    description = "query '%s'" % description if options[:query]
    self.log_msg("starting %s" % description, options)
    t0 = Time.now
    result = yield
    self.log_msg("%s finished in %ss" % [description, Time.now - t0], options)
    result
  end
end