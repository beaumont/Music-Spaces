# The DummyMonetaryAccount is used to activate accounts so that
# they may accept money without having an actual processor attached.
class DummyMonetaryAccount < MonetaryProcessorAccount
  after_create :automatically_verify
  
  protected
  
  def automatically_verify
    self.verify!
  end
end
