require File.dirname(__FILE__) + '/../test_helper'

class ContentTest < Test::Unit::TestCase
  # fixtures :contents

  def test_without_monitoring
    @content = Content.new
    assert_raise(ActiveRecord::StatementInvalid) {
      Content.without_monitoring do
        @content.save
      end
    }
  end
  
  def test_instance_without_monitoring
    @content = Content.new(:user_id => 5)
    assert_raise(Kroogi::Error) { @content.save }
  end
  
end
