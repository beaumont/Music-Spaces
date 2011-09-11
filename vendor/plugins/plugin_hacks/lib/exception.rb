class Exception
  alias old_inspect inspect
  def inspect
    result = old_inspect
    result = result + "\n  " + application_backtrace.join("\n  ") if !backtrace.nil?
    result
  end
end
