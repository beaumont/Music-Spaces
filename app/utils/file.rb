class Utils::File

  def self.pack_to_zip(path, options = {})
    options[:archive_name] ||= File.basename(path)
    `cd #{path} && zip -0 #{options[:archive_name]} *`
  end

end
