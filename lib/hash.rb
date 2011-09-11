require "metaid"
class Hash
  # AUTOTRANSLATION HAS BEEN DISABLED. A good idea, but it breaks the string importation script for our translators
  
  # # add translations to constants in models
  # # like BLAH = { :hey => { :name => "I should be translated", :id => 6 }}.auto_translate(:name)
  # def auto_translate(*key_names)
  #   # define meta definition to Hash instance
  #   # everything inside of here is evaluated with the Hash instance as self
  #   meta_def :[] do |s| #see metaid.rb
  #       v = super(s)
  #     if (v && !key_names.empty? && v.is_a?(Hash))
  #       # run translation on specified keys and return modifidied, translated hash key
  #       v.merge(Hash[*key_names.collect{ |k| [k,v[k].t] if v[k] }.compact.flatten])
  #       # tlate = lambda do |key,value|
  #         
  #       # end
  #     else
  #       # or just return what you wanted.
  #       v
  #     end
  #   end
  #   # return self at end of method so that your constant isn't nil
  #   self
  # end
  
  # Usage { :a => 1, :b => 2, :c => 3}.only(:b, :c) => { :b => 2, :c => 3}
  def only(*keys)
    self.reject { |k,v|
      !keys.include? k.to_sym
    }
  end
end