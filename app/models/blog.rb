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

class Blog < Textentry
  
  has_one :blogentry, :class_name => 'LiveJournalEntry', :foreign_key => 'content_id', :order => "posted_at DESC"
  
  has_attachment :storage => :db_file, 
      :content_type => %w(text/html text/plain), 
      :size => (0..512.kilobyte)
  
  def validate
    if self.filename.blank?
      self.errors.add_to_base('You should probably post something here'.t) 
      raise ActiveRecord::RecordInvalid.new(self)
    end
    attachment_size_valid?
  end
    
  def post_url
    "http://#{self.user.livejournal_name}.livejournal.com/#{self.filename}"
  end
  
  def editable?
    false
  end
  
  def post=(entry)
    self.content_type    = 'text/html'
    self.filename        = 'untitled.html'
    return nil if entry.nil?
    self.blogentry = entry
    self.is_in_gallery = false
    self.is_in_startpage = false
    self.cat_id = Content::CATEGORIES[:blog][:id]
    self.title = entry.subject
    self.filename = ((entry.journal_item_id.to_i << 8) + entry.anum).to_s + '.html'
    self.tag_list = entry.taglist
    type = self.user.project? ? Relationshiptype.founders : Relationshiptype.nobody
    logger.debug "Security: #{entry.security}"
    case entry.security
      when :public
        type = Relationshiptype.everyone
      when :friends
        # based on their custom selected friend_circle
        type = entry.account.friend_circle
      else
        type = Relationshiptype.nobody
    end
    self.created_at = entry.posted_at
    self.relationshiptype_id = type
    self.temp_data = 'LiveJournalEntry-' + entry.journal_item_id.to_s
  end

  def post
    return nil if self.id.nil? || self.blogentry.nil?
    return self.blogentry.event_formatted
  end
  
  def cut
    return nil if self.id.nil? || self.blogentry.nil?
    return self.blogentry.event_cut
  end
  
  def full_filename 
    self.filename
  end
  
  # Sets the relationshiptype_id based on 
  def update_security!(privacy_menu_int)
    self.relationshiptype_id = privacy_menu_int
    save(false)
  end
  
end
