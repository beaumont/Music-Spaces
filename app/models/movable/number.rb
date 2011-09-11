# == Schema Information
# Schema version: 20090211222143
#
# Table name: movable_numbers
#
#  id                   :integer(11)     not null, primary key
#  number               :integer(11)
#  cost                 :integer(11)
#  cost_local           :integer(11)
#  force_prefix         :string(255)
#  movable_operator_id  :integer(11)
#  formatted_cost       :string(255)
#  formatted_cost_local :string(255)
#  version              :integer(11)     default(1)
#

class Movable::Number < ActiveRecord::Base
  set_table_name 'movable_numbers'
  belongs_to :operator, :foreign_key => 'movable_operator_id', :class_name => 'Movable::Operator'

  def self.dump_to_js(nums, options)
    min = options[:amounts_more_than] || 0
    arr = []
    nums.reject {|num| num.cost < min*100}.each do |n|
      arr << n.attributes.except(:id)
    end
    return arr
  end
  
end
