# == Schema Information
# Schema version: 20081006211752
#
# Table name: db_store
#
#  id      :integer(11)     not null, primary key
#  content :text
#

class DbStore < ActiveRecord::Base
  set_table_name :db_store
  xss_terminate :except => [:content]  # BE SURE TO ESCAPE THESE IN VIEWS!
end
