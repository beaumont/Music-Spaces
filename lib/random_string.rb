class RandomString
  class <<self
    include StringUtilsMixin
  end

  def self.generate(len=10)
    random_alphanum_string(len)
  end
end
