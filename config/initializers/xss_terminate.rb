# Patch for 2.2 xss_terminate
RailsSanitize.class_eval do
	def self.full_sanitizer
	  @full_sanitizer ||= HTML::FullSanitizer.new
	end
end
