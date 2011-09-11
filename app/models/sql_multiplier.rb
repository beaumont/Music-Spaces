class SqlMultiplier
  #this is to convert 'upper(name) like :like'  to '(upper(name) like :like1) OR (upper(name) like :like2) OR (upper(name) like :like3)'
  def self.multiply_condition(base, var_name, array)
    (1..array.size).to_a.map {|i| base.gsub(var_name, "#{var_name}#{i}")}.map {|part| "(#{part})"}.join(" AND ")
  end

  #this is to convert (':like', ['a%', 'b%', 'c%']) to {:like1 => 'a%', :like2 => 'b%', :like3 => 'c%'}
  def self.expand_params(name, values)
    name = name.to_s
    result = {}
    values.each_with_index {|value, i| result["#{name}#{i + 1}".to_sym] = value}
    result
  end
end
