# Cache Money Money
#require 'cache_money'
#$memcache = Cash::Mock.new

module TestUtilsMixin

def assert_no_errors(object, options = {})
  options.reverse_merge! :validate => false, :require_object => true
  return if object.nil? && !options[:require_object]
  assert_not_nil object, "checked object should not be nil"
  object.valid? if options[:validate]
  assert_equal [], object.errors.full_messages, options[:message] 
end

def assert_errors(object, opts = {})
  opts = {:validate => false}.merge(opts)
  assert_not_nil object
  object.valid? if opts[:validate]
  assert_not_equal [], object.errors.full_messages
  if opts[:on]
    if opts[:on].is_a? Hash
      opts[:on].each_pair do |attr, msg|
        assert_equal msg, object.errors.on(attr), "expected '#{msg}' error on '#{attr}' attribute. All errors: #{object.errors.full_messages.inspect}"
      end
    else
      opts[:on] = [opts[:on]] if !opts[:on].is_a?(Array)
      opts[:on].each { |attr| assert object.errors.on(attr), "expected error on '#{attr}' attribute"}
    end
  end
  if opts[:match]
    match = Regexp.new(opts[:match].source.downcase)
    messages = object.errors.full_messages.map {|m| m.downcase}
    result = messages.any? {|m| m =~ match}
    assert result, "some of errors (#{messages.inspect}) must match #{match.inspect}" 
  end

end

end