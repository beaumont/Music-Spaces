# == Schema Information
# Schema version: 20090211222143
#
# Table name: extra_inbox_fields
#
#  id                  :integer(11)     not null, primary key
#  inbox_id            :integer(11)
#  tagline             :string(255)
#  tagline_ru          :string(255)
#  tagline_fr          :string(255)
#  images              :boolean(1)      default(TRUE)
#  tracks              :boolean(1)      default(TRUE)
#  videos              :boolean(1)      default(TRUE)
#  writings            :boolean(1)      default(TRUE)
#  archived            :boolean(1)
#  feature_most_recent :boolean(1)
#  created_at          :datetime
#  updated_at          :datetime
#

class ExtraFieldset::Inbox < ActiveRecord::Base
  set_table_name 'extra_inbox_fields'
  belongs_to :inbox

  translates :tagline, :base_as_default => true
  
end
