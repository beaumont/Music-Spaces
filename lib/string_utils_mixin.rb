module StringUtilsMixin

  #I don't like this paramaters order, but let's be consistent with ActionView::Helpers::TextHelper
  def pluralize_without_count(count, string)
    if count == 1
      string
    else
      string.pluralize
    end
  end        
             
  #converts string like '%number %items found' to '%s %s found'.
  #Note that it's  not suitable for mixed cases like '%d %items found'
  def normalize_placeholders(string)
    string.gsub(/%[\w$]+/, '%s')
  end

  ALLOWED_PSW_CHARACTERS = ("A".."Z").to_a + ("a".."z").to_a + ("0".."9").to_a
  #generate a random password consisting of strings and digits
  def random_alphanum_string(size)
    Array.new(size) { ALLOWED_PSW_CHARACTERS[Kernel.rand(ALLOWED_PSW_CHARACTERS.length)] }.join
  end
  
end