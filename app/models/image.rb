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
class Image < Content

  MAX_SIZE = 6.megabytes
  has_attachment :storage => :s3, :path_prefix => 'content/images',
    #has_attachment :storage => :file_system, :path_prefix => 'content/images',
    :thumbnails => { :big => '300x300>', :thumb => '150>',  :preview => '490>', :small => '80>', :tiny => '50>', :square => '100x100!'},
    :thumbnail_class => 'ImageThumbnail',
    :size => (0..MAX_SIZE),
    :content_type => %w(image/gif image/png image/pjpeg image/jpeg),
    :processor => :MiniMagick
        
  # Do not use validates_as_attachment, see validates_as_attachment_improved method in attachement_fu hack instead instead,
  # all calls here are to the things we want are there, built-in validates_as_attachment is a bit rough with error messages
  validates_as_attachment_improved
  validate_on_create    :check_quota, :if => lambda {|image| image.class == Image}

  # TODO watermark the largest thumbnail so it isn't downloadable
  # after_attachment_saved do |record|
  #  # TODO only add watermark to largest thumbnail
  #  if record.thumbnail.nil?
  #    full_path = File.join(RAILS_ROOT, 'public/', record.public_filename)
  #
  #    img = MiniMagick::Image.from_file(full_path)
  #
  #    width = img[:width]
  #    height = img[:height]
  #
  #     if width > 150 && height > 150
  #      img.combine_options do |c|
  #        c.gravity 'SouthWest'
  #        # This is RAILS_ROOT/images/watermark.gif
  #        c.draw "image Over 0,0 0,0 \"images/watermark.gif\""
  #      end
  #      # push to s3 and not write
  #      img.write(full_path)
  #
  #   end
  # end
  #
  def update_userpic!(should_this_be)
    if !should_this_be && user.profile.userpic == self
      self.clear_userpic!
    elsif should_this_be && user.profile.userpic != self
      self.make_userpic!
    end
  end
    
  # Clear owner's userpic
  def clear_userpic!
    return true if user.profile.userpic.nil?
    user.profile.userpic.update_attributes(:cat_id => Content::CATEGORIES[:image][:id])
    user.profile.update_attributes(:userpic_id => nil)
  end
    
  # Makes this picture the owner's userpic
  def make_userpic!
    self.cat_id = Content::CATEGORIES[:userpic][:id]
    self.relationshiptype_id = Relationshiptype.everyone
    self.save!
    if user.profile.userpic
      user.profile.userpic.update_attributes(:cat_id => Content::CATEGORIES[:image][:id])
    end
    user.profile.userpic_id = self.id
    user.profile.save!
  end
    
  attr_accessor :editing_file
  def validate
    if !new_record? && editing_file
      attachment_attributes_valid_improved
      self.editing_file = false
    end
  end
    
  before_thumbnail_saved do |thumb|
    thumb.user_id = thumb.parent.user_id
  end
    
  def thumb(size)
    thumb = self.thumbnails.find_by_thumbnail(size.to_s)
    log.debug "thumb.nil?: %s" % thumb.nil?
    if thumb.nil?
      thumb =  Image.new
      thumb.extend ImageExtender
    end
    return thumb
  end
    
    
  def self.category_menu
    choped, others = CATEGORIES.partition {|key, val| val[:type] == :Image }
    choped.collect{|key, val| [val[:name] || key.to_s, val[:id]]}
  end
    
  #after_resize do |clazz, image|
  #end
  #after_attachment_saved

  def userpic?
    self.cat_id == Content::CATEGORIES[:userpic][:id]
  end
    
  def undeletable?
    return "This image cannot be deleted: it's used as default cover art for Music Contests" if self.id == APP_CONFIG.music_contest_default_cover
  end

  def own_cover_art_url
    self.thumb(:thumb).public_filename
  end
end

module ImageExtender
  #module ClassMethods
  def public_filename(thumbnail = nil)
    '/images/missing_image.png'
  end
  def width
    75
  end
  def height
    75
  end
  #end
end
