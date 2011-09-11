module Admin
  class BaseController < ApplicationController
    layout 'admin'
    before_filter :admin_required
    helper(application_helpers(:admin)) # include all helpers, all the time
    skip_before_filter :write_site_activity_log

    # def authorized?(user)
    #   user.in_role?(Role::ADMIN)
    # end
  end
end