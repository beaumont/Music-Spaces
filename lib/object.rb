class Object  
  ##
  #   @person ? @person.name : nil
  # vs
  #   @person.try(:name)
  def try(method, returns = nil)
    return send(method) if respond_to?(method)
    returns
  end
  
  ##
  # return result of the first method that gives a true result or false if none
  # <tt>@something.attempt_methods(:method?, :other_method?)
  def attempt_methods(*args)
    method = args.detect{ |meth| !!try(meth) === true } 
    method ? send(method) : false
  end
end