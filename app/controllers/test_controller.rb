class TestController < ApplicationController

  skip_before_filter :run_basic_auth
  
end
