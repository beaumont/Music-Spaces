# == Schema Information
# Schema version: 20081006211752
#
# Table name: admission_pass_name_list
#
#  id   :integer(11)     not null, primary key
#  name :string(255)
#

class MiroLikesRandomNames < ActiveRecord::Base
  set_table_name :admission_pass_name_list
  
  # find some random names and join them in a string
  def self.for_admission_passes(how_many = 2)
    find(:all, :limit => how_many, :select => "name", :order => "rand()").collect(&:name) * ' '
  end
end
