# == Schema Information
# Schema version: 20081028193108
#
# Table name: movable_operators
#
#  id                 :integer(11)     not null, primary key
#  name               :string(255)
#  mid                :string(255)
#  movable_country_id :integer(11)
#  version            :integer(11)     default(1)
#

class Movable::Operator < ActiveRecord::Base
  set_table_name 'movable_operators'
  
  belongs_to :country, :foreign_key => 'movable_country_id', :class_name => 'Movable::Country'
  has_many :numbers, :foreign_key => 'movable_operator_id', :class_name => 'Movable::Number'
  
  def self.dump_to_js(operators, options)
    arr = {}
    operators.each do |o|
      arr.merge!({o.id => o.attributes.except(:id).merge(:numbers => Movable::Number.dump_to_js(o.numbers, options))})
    end
    return arr
  end
end
