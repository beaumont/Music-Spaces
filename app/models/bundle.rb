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

class Bundle < Content
  include Id3TagsLoader

  belongs_to :bundle_for, :class_name => BasicFolderWithDownloadables.name, :foreign_key => 'downloadable_album_id'

  has_attachment :storage => :s3, :path_prefix => 'content/bundle',
      :size => (0..800.megabytes),
      :s3_access => :private,
      :custom_validator => :maybe_load_id3_tags,
      :write_content_type => lambda {|o| o.content_type['zip'] ? o.content_type : 'application/octet-stream'}
 #   :content_type => %w(application/zip application/gzip)
  validates_as_attachment_improved

  named_scope :original_contest_tracks, :conditions => "cat_id ='#{CATEGORIES[:original_contest_track][:id]}'" 
  named_scope :original_contest_samples, :conditions => "cat_id ='#{CATEGORIES[:bundle][:id]}'" 

  # Do not use validates_as_attachment, see validates_as_attachment_improved method in attachement_fu hack instead instead, all calls here are to the things we want
  # are there, built-in validates_as_attachment is a bit rough with error messages
#   validates_as_attachment_improved

  attr_accessor :editing_file

  def initialize(attribs)
    super(attribs)
    unless attribs[:original_contest_track]
      self.original_contest_track = self.mp3_file?
    end
  end

  def maybe_load_id3_tags
    load_id3_tags if mp3_file?
  end

  def init(container)
    self.user_id = container.user_id
    self.user = container.user
    self.cat_id ||= Content::CATEGORIES[:bundle][:id]
    self.is_in_startpage = false
    self.is_in_gallery = false
    self.author_id = container.author_id
    self.created_by_id = container.author_id
    self.relationshiptype_id = Relationshiptype.nobody
  end

  def validate
    if !new_record? && editing_file
 #     attachment_attributes_valid_improved
      self.editing_file = false
    end
  end

  # protection, this will make public_filename return authenticated s3 filename
  def s3_url
    return self.authenticated_s3_url(:expires_in => current_user.admin? ? 1.week : 24.hours, :use_ssl => true)
  end


  # shows the content owner the security level of their content
  #
  def restriction_level
    return 0 # only user itself is allowed
  end

  # checks if user_or_project has permission to see the content (nobody can)
  def is_view_permitted?(user_or_project = nil)
    return false
  end

  def original_contest_track
    self.cat_id == CATEGORIES[:original_contest_track][:id]
  end

  def original_contest_track=(value)
    if value.to_s == 'false'
      self.cat_id = CATEGORIES[:bundle][:id]
    else
      self.cat_id = CATEGORIES[:original_contest_track][:id]
    end
  end

  def mp3_file?
    filename.ends_with?('.mp3')
  end

  def artist
    bundle_for.user.display_name
  end
end
