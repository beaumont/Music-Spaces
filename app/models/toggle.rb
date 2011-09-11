# == Schema Information
# Schema version: 20090211222143
#
# Table name: toggles
#
#  id    :integer(11)     not null, primary key
#  name  :string(255)
#  value :boolean(1)
#

# == Schema Information
# Schema version: 20090115130316
#
# Table name: toggles
#
#  id    :integer(11)     not null, primary key
#  name  :string(255)
#  value :boolean(1)
#

class Toggle < ActiveRecord::Base
# Utility model used e.g. to track class variable cache expiry many different model instances (app servers)

  def self.toggle(name, raise_on_none = false)
    tog = Toggle.find(:first, :conditions => {:name => name})
    if tog.nil? && raise_on_none
      raise "No toggle found for #{name}"
    end
    return tog
  end

  def self.method_missing(method_name, *parameters)
    method_name = method_name.is_a?(Symbol) ? method_name.id2name : method_name.to_s
    op = method_name[/(=|\?|\!)$/]
    name = method_name.gsub(/=|\?|\!$/, '')

    if op == '?' # Boolean query
      toggle(name, raise_on_none = true) && !!toggle(name).value
    elsif op == '!' # Set to true (find or create)
      toggle(name) ? toggle(name).update_attribute(:value, true) : Toggle.create(:name => name, :value => true)
    elsif op == '=' # Set to value (find or create)
      toggle(name) ? toggle(name).update_attribute(:value, parameters[0]) : Toggle.create(:name => name, :value => parameters[0])
    else # Show actual value
      toggle(name, raise_on_none).value
    end

  end
  
end
