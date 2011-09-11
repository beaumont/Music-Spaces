class BackgroundController < ApplicationController
  skip_before_filter :choose_system_message
  skip_before_filter :write_site_activity_log

  IMAGES = Dir.entries("#{RAILS_ROOT}/public/backgr").delete_if { |x| x.match /^\./ }.freeze

  def random_image
    file = IMAGES[rand(IMAGES.size)]
    return "/backgr/#{file}"
  end
  
  def get
    redirect_to random_image and return
  end
  
end