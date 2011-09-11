# == Schema Information
# Schema version: 20081006211752
#
# Table name: profile_types
#
#  id              :integer(11)     not null, primary key
#  profile_id      :integer(11)     default(1), not null
#  user_id         :integer(11)     default(1), not null
#  profile_name_id :integer(11)
#

class ProfileType < ActiveRecord::Base
  # This is no longer used, and only remains here to make migrations happy
  # KILLME when bundle migrations
end
