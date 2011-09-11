Technoweenie::AttachmentFu::Processors::MiniMagickProcessor.module_eval do
  def resize_image(img, size)
    size = size.first if size.is_a?(Array) && size.length == 1
    if size.is_a?(Fixnum) || (size.is_a?(Array) && size.first.is_a?(Fixnum))
      if size.is_a?(Fixnum)
        size = [size, size]
        img.resize(size.join('x'))
      else
        img.resize(size.join('x') + '!')
      end
    else
      n_size = [img[:width], img[:height]] / size.to_s
      if size.ends_with? "!"
        aspect = n_size[0].to_f / n_size[1].to_f
        ih, iw = img[:height], img[:width]
        w, h = (ih * aspect), (iw / aspect)
        w = [iw, w].min.to_i
        h = [ih, h].min.to_i
        if ih > h
          shave_off =  ((ih - h) / 2).round
          img.shave("0x#{shave_off}")
        end
        if iw > w
          shave_off = ((iw - w ) / 2).round
          img.shave("#{shave_off}x0")
        end
        img.resize(size.to_s)
      else
        img.resize(size.to_s)
      end
      self.temp_path = img
    end
  end
end


Technoweenie::AttachmentFu::ClassMethods.module_eval do
  # Performs common validations for attachment models.
  def validates_as_attachment_improved
    validate_on_create    :attachment_attributes_valid_improved
  end
end

Technoweenie::AttachmentFu::InstanceMethods.module_eval do
  require 'id3lib'
  
  def guess_mime_type_by_filename(filename)
    require 'mime/types'
    types = MIME::Types.type_for(filename)
    if !types.empty?
      content_type = types[0].content_type
      return content_type
    end
    return nil
  end

  def guess_mime_type_by_magic(path)
    mime_type = MIME.check_magics(path)
    mime_type.type if mime_type
  end

  # the default validator is a bit rough
  def attachment_attributes_valid_improved
    if self.temp_path.blank? || self.filename.blank? || self.size.blank?
      self.errors.add_to_base("We did not get the file you tried to upload, please try again.".t)
      raise ActiveRecord::RecordInvalid.new(self)
    end


    self.content_type = guess_mime_type_by_magic(self.temp_path)
    self.content_type = guess_mime_type_by_filename(self.filename) if self.content_type.blank?

    if attachment_options[:content_type]
      errors.add_to_base("The file you uploaded is not a valid #{self.class.name.downcase} file. It appears to be of type: %s." / self.content_type) unless attachment_options[:content_type].include?(self.content_type)
    end

    if attachment_options[:custom_validator]
      self.send(attachment_options[:custom_validator])
    end

    raise ActiveRecord::RecordInvalid.new(self) if !self.errors.empty?

    attachment_size_valid?
  end
  
  def attachment_size_valid?
    # now do what attachment_fu does with size
    unless attachment_options[:size].include?(self.size)
      self.errors.add_to_base("The size of file you uploaded exceeds our upload limit.".t)
    end
  end
  
end


Technoweenie::AttachmentFu::Backends::S3Backend.module_eval do  
  protected
  def destroy_file
    begin
      AWS::S3::S3Object.delete full_filename, bucket_name
    rescue Exception => e
      puts "Error encountered deleting (rescued, deletion occurred anyway): #{e}"
      # logit ? "Error deleting, but we dont care: #{e}"
    end
  end
end

# Technoweenie::AttachmentFu::Processors::ImageScienceProcessor.module_eval do
# 
#   def resize_image(img, size)
#     # create a dummy temp file to write to
#     self.temp_path = write_to_temp_file(filename)
#     grab_dimensions = lambda do |img|
#       self.width  = img.width  if respond_to?(:width)
#       self.height = img.height if respond_to?(:height)
#       img.save temp_path
#       self.size = File.size(self.temp_path)
#       callback_with_args :after_resize, img
#     end
#     size = size.first if size.is_a?(Array) && size.length == 1
#     if size.is_a?(Fixnum) || (size.is_a?(Array) && size.first.is_a?(Fixnum))
#       if size.is_a?(Fixnum)
#         img.thumbnail(size, &grab_dimensions)
#       else
#         img.resize(size[0], size[1], &grab_dimensions)
#       end
#     else
#       n_size = [img.width, img.height] / size.to_s
#       if size.ends_with? "!"
#         aspect = n_size[0].to_f / n_size[1].to_f
#         ih, iw = img.height, img.width
#         w, h = (ih * aspect), (iw / aspect)
#         w = [iw, w].min.to_i
#         h = [ih, h].min.to_i
#         img.with_crop( (iw-w)/2, (ih-h)/2, (iw+w)/2, (ih+h)/2) {
#           |crop| crop.resize(n_size[0], n_size[1], &grab_dimensions )
#         }
#       else
#         img.resize(n_size[0], n_size[1], &grab_dimensions)
#       end
#     end
#   end
# end









# ====================================================================================================================================
# = Better cloning of attachment_fu data - http://www.williambharding.com/blog/rails/rails-faster-clonecopy-of-attachment_fu-images/ =
# ====================================================================================================================================

module Technoweenie # :nodoc:
  module AttachmentFu # :nodoc:
		module InstanceMethods
			attr_writer :skip_thumbnail_processing
		
			# Added by WBH from http://groups.google.com/group/rubyonrails-talk/browse_thread/thread/e55260596398bdb6/4f75166df026672b?lnk=gst&q=attachment_fu+copy&rnum=3#4f75166df026672b
			# This is intended to let us make copies of attachment_fu objects
			# Note:  This makes copies of the main image AND each of its prescribed thumbnails
			def create_clone
				c = self.clone
				
        # Copy these over more intelligently than making attachment_fu re-generate all thumbs
				self.thumbnails.each { |t|
					n = t.clone
					img = t.create_temp_file
					n.temp_path = img 	#img.path		-- Commented so that img wont get garbage collected before c is saved, see the thread, above.
					n.save_to_storage
					c.thumbnails<<n
				}
				
				img = self.create_temp_file
				
				# We'll skip processing (resizing, etc.) the thumbnails, unless the thumbnails array was empty.  If the array is empty,
				# it's possible that the thumbnails for the main image might have been deleted or otherwise messed up, so we want to regenerate
				# them from the main image
				c.skip_thumbnail_processing = !self.thumbnails.empty? 
				c.temp_path = img		#img.path
				c.save_to_storage
				
				c.save_without_validation!
				return c
			end 
			
			protected
			
			# Cleans up after processing.  Thumbnails are created, the attachment is stored to the backend, and the temp_paths are cleared.
      def after_process_attachment
        if @saved_attachment
          if respond_to?(:process_attachment_with_processing) && thumbnailable? && !@skip_thumbnail_processing && !attachment_options[:thumbnails].blank? && parent_id.nil?
            temp_file = temp_path || create_temp_file
            attachment_options[:thumbnails].each { |suffix, size| create_or_update_thumbnail(temp_file, suffix, *size) }
          end
          save_to_storage
          @temp_paths.clear
          @saved_attachment = nil
          callback :after_attachment_saved
        end
      end

		end
	end
end

module Technoweenie::AttachmentFu
  module S3Faker
    def authenticated_s3_url(*args)
      self.public_filename
    end
  end

  module S3PublicFilenameFixer
    def public_filename
      s3_url
    end
  end
  
  module HackedActMethods
    include Technoweenie::AttachmentFu::ActMethods

    def has_attachment(options)
      avoid_s3 = APP_CONFIG.avoid_s3 && options[:storage] == :s3
      if avoid_s3
        options[:storage] = :file_system
        options[:path_prefix] = 'public/attachments/' + options[:path_prefix] if options[:path_prefix]
      end
      super(options)
      if avoid_s3
        include S3Faker
      else
        include S3PublicFilenameFixer if options[:storage] == :s3
      end
    end
  
  end
end