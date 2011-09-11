class MonetaryProcessorAccounts::BaseController < ApplicationController
  before_filter :login_required
  
end