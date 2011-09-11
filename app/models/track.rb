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

require "shared-mime-info"

class Track < Content
    include Id3TagsLoader

    MAX_SIZE = 150.megabytes 
    has_attachment :storage => :s3, :path_prefix => 'content/audio', 
        :size => (0..MAX_SIZE),
#        :content_type => %w(audio/x-mpeg application/mp3 audio/mpeg3 audio/mpeg audio/x-mpeg-3),
        :custom_validator => :validate_uploaded_file_type
    
    # Do not use validates_as_attachment, see validates_as_attachment_improved method in attachement_fu hack instead instead, all calls here are to the things we want
    # are there, built-in validates_as_attachment is a bit rough with error messages
    validates_as_attachment_improved
    validate_on_create    :check_quota
    translates :artist, :album, :title, :description, :base_as_default => true
    
    # Downloadable version of this track
    has_one :file_download, :foreign_key => :parent_id, :dependent => :destroy
    
    
    # Toggle download-ability. A boolean value and the creation of the actual download instance.
    def toggle_downloadable!(turning_on)
      Content.transaction do
        if turning_on
          update_attribute(:downloadable, true)
          if file_download 
            file_download.save # Force update
          else
            FileDownload.create_from_track(self)
          end
        else
          update_attribute(:downloadable, false)
          file_download.destroy if file_download
        end
      end
    end
    
    def after_save
      if filename_changed? && file_download
        file_download.save # Triggers the download to update (copy over the new file)
      end
      true
    end
    
    attr_accessor :editing_file
    def validate
      if !new_record? && editing_file
        attachment_attributes_valid_improved
        self.editing_file = false
      end
    end
    
    def validate_uploaded_file_type
      invalid_tags = (Mp3Info.new(self.temp_path).tag rescue []).empty?
      # now we deny everything but mp3 - turned out we see AAC's tags but player doesn't play it
      extension = File.extname(self.filename)[1..-1]
      if extension.downcase != 'mp3'
        self.errors.add_to_base("The file you uploaded is not a valid #{self.class.name.downcase} file. We accept only MP3s and you've supplied %s." / extension.upcase)
        # "The file you uploaded is not a valid track file. We accept only MP3s and you've supplied %s.".t
      end
      self.errors.add_to_base("This file is missing ID3 tags or not an MP3. Please provide valid MP3 file with filled ID tags (use any MP3 editor to add them) and try again.".t) if invalid_tags && self.errors.empty?

      # read and store ID3 tags and mp3 info once we are positive that file is mp3
      load_id3_tags if self.errors.empty?
    end

    # Sanitizes a filename.
    # overrides attachment fu to avoid non-latinic filenames which are said to not play well with flash 
    def filename=(new_name)
      write_attribute :filename, Russian.translit(sanitize_filename(new_name))
    end
    
  def editable?
    result = super
    result = false if result && self.albums.any? {|a| a.is_a?(MusicAlbum) && a.downloadable?}
    result
  end

  def commentable?
    self.active?
  end

  def assign_to_album(album_id)
    album = super(album_id)
    if album.is_a?(MusicContest)
      ContestSubmission.create!(:content_id => self.id, :level => 0, :contest_id => album.id,
                                :created_by_id => self.created_by_id)      
    end
    album
  end
end
