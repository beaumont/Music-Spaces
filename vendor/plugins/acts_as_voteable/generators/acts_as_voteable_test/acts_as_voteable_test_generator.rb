class ActsAsVoteableTestGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.directory File.join('test/unit', class_path)
      
      m.template(
        'unit_test.erb',  
        File.join(
          'test/unit', class_path, "acts_as_voteable_#{file_name}_test.rb"
        )
      )
    end
  end
end