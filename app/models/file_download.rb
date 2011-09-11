# == Schema Information
# Schema version: 20090212135816
#
# Table name: contents
#
#  id                    :integer(11)     not null, primary key
#  user_id               :integer(11)     not null
#  title                 :string(255)
#  description           :text
#  type                  :string(255)
#  content_type          :string(255)
#  filename              :string(255)
#  filepath              :string(255)
#  size                  :integer(11)
#  parent_id             :integer(11)
#  thumbnail             :string(255)
#  width                 :integer(11)
#  height                :integer(11)
#  created_at            :datetime        not null
#  updated_at            :datetime        not null
#  is_in_gallery         :boolean(1)
#  db_file_id            :integer(11)
#  foruser_id            :integer(11)
#  cat_id                :integer(11)     default(0), not null
#  is_in_startpage       :boolean(1)
#  is_in_myplaylist      :boolean(1)
#  created_by_id         :integer(11)     default(0), not null
#  updated_by_id         :integer(11)     default(0), not null
#  author_id             :integer(11)     default(0), not null
#  artist                :string(80)
#  album                 :string(80)
#  year                  :integer(4)
#  genre                 :string(60)
#  bitrate               :integer(4)
#  chanels               :string(20)
#  samplerate            :integer(4)
#  length                :integer(6)
#  post_db_store_id      :integer(11)
#  language_code         :string(8)
#  owner                 :string(255)
#  title_ru              :string(255)
#  description_ru        :text
#  title_fr              :string(255)
#  description_fr        :text
#  post_db_store_ru_id   :integer(11)
#  post_db_store_fr_id   :integer(11)
#  state                 :string(255)     default("active")
#  state_changed_at      :datetime
#  artist_ru             :string(255)
#  album_ru              :string(255)
#  artist_fr             :string(255)
#  album_fr              :string(255)
#  downloadable          :boolean(1)
#  downloadable_album_id :integer(11)
#  relationshiptype_id   :integer(11)
#  body_project_id       :integer(11)
#

require 'digest'

class FileDownload < Content
  # Downloadable tracks
  
  has_attachment :storage => :s3, :path_prefix => 'content/file_download',
    :size => (0..800.megabytes),
    :s3_access => :private,
    :content_type => %w(audio/x-mpeg application/mp3 audio/mpeg3 audio/mpeg audio/x-mpeg-3)

  belongs_to :parent, :class_name => 'Content'
  before_save :ensure_file_and_filename
  validate :connected_to_content_item
  
  def self.create_from_track(t)
    returning FileDownload.new do |fd|

      # Copy over all the track-specific info from the parent
      %w(user_id size bitrate samplerate length chanels title artist album genre year).each do |attrib|
        fd[attrib] = t.send(attrib)
      end
    
      fd.parent_id = t.id
      fd.save!
    end
  end
  
  # copied from method of same name in bundle.rb
  def s3_url
    return self.authenticated_s3_url(:expires_in => 24.hours, :use_ssl => true)
  end

  
  protected
  
  def connected_to_content_item
    errors.add_to_base("No connected content item found") unless parent
  end

  # Create/update connection between this file download to its parent
  def ensure_file_and_filename
    return true if up_to_date_with_parent?
    
    # Kill existing file in S3, if any - before rename
    if filename && AWS::S3::S3Object.exists?(full_filename, bucket_name)
      AWS::S3::S3Object.delete(full_filename, bucket_name)
    end

    set_filename_from_parent
    copy_file_from_parent
    true
  end



  # Different path prefix for full_filename, so we can just copy over the parent's name.
  # We don't want users do be able to guess download URLs based on public names, though, so add a some obfuscation
  def set_filename_from_parent
    components = parent.filename.split('.')
    if components.size > 1
      ext = components.last
      name = components[0, components.size - 1].join('.')
    else
      ext = 'mp3'
      name = parent.filename
    end
    name = Digest::SHA1.hexdigest("KroogiFileDownload-#{id}-#{name}")
    
    self.filename = "#{name}.#{ext}"
  end

  # Overriding save_to_storage to copy over the file from the parent item already on S3, rather than reuploading
  def copy_file_from_parent
    logger.debug "[FileDownload] Copying from #{parent.full_filename} to #{full_filename} (in #{bucket_name})"
    
    # Kill existing file in S3, if any - after rename
    if filename && AWS::S3::S3Object.exists?(full_filename, bucket_name)
      AWS::S3::S3Object.delete(full_filename, bucket_name)
    end
    
    # Right now there's nothing where full_filename points to -- let's copy over the file from the parent's S3Object
    AWS::S3::S3Object.copy(
      parent.full_filename,
      full_filename,
      bucket_name,
      :access => :private
    )
    
    # Skip attachment_fu's automatic rename_file called on before_update
    @old_filename = filename
    true
  end

  # If false, need to update filename/file contents from parent
  def up_to_date_with_parent?
    !filename.blank? && 
    AWS::S3::S3Object.exists?(self.full_filename, bucket_name) &&
    AWS::S3::S3Object.exists?(parent.full_filename, bucket_name) &&
    AWS::S3::S3Object.find(self.full_filename, bucket_name).etag == AWS::S3::S3Object.find(parent.full_filename, bucket_name).etag
  end

end
