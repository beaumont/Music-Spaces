require "active_support"
class String
  def to_hash
    ActiveSupport::JSON.decode self
  end
  
  # http://rails.lighthouseapp.com/projects/8994/tickets/867-undefined-method-length-for-enumerable#ticket-867-13
  def chars
    ActiveSupport::Multibyte::Chars.new(self)
  end
  alias_method :mb_chars, :chars

  def email?
    self =~ User::EMAIL_REGEX
  end
end 