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

# TODO: rename this class to Announcement
class Board < Textentry
  has_one :announcement, :dependent => :destroy
  named_scope :for_user, lambda {|who| { :conditions => ['user_id = ?', who.id]} }
  named_scope :with_details, lambda { { :joins => "JOIN announcements on announcements.board_id = contents.id"} }
  named_scope :announcements, lambda { {:conditions => ['priority = ?', true]} }
  named_scope :usernotes, lambda { {:conditions => ['priority = ?', false]} }
  named_scope :ordered, lambda { {:order => 'contents.id desc'} }
  named_scope :top, lambda {|limit| {:limit => limit} } 

  def self.announcements_of(user, options = {})
    options.reverse_merge!(:kind => :announcements)
    result = self.with_details.active.for_user(user).ordered
    result = result.send(options[:kind]) unless options[:kind] == :all
    result = result.top(options[:limit]) if options[:limit]
    result
#    Board.active.find(:all, :conditions => {:user_id => user.id, :foruser_id => nil}, :limit => lim, :include => [:announcement], :order => 'contents.id desc')
  end

  def self.usernotes_of(user, options = {})
    announcements_of(user, options.merge(:kind => :usernotes))
  end

   def self.startpage_announcements_of(user)
    Board.active.find(:all, :conditions => {:user_id => user.id, :foruser_id => nil, :is_in_startpage => true}, :limit => 50, :include => [:announcement], :order => 'announcements.priority desc, contents.created_at desc')
  end
  
  def self.hidden_startpage_announcements_of(user)
    return [] unless user
    Board.active.find(:all, :conditions => {:user_id => user.id, :foruser_id => nil, :is_in_startpage => false}, :limit => 50, :order => 'created_at desc')
  end  
  
  def after_initialize
    begin
        # TODO do this the right way...
        self.build_announcement unless self.announcement
    rescue ActiveRecord::StatementInvalid
      nil # For migrations, where announcement table doesn't yet exist
    end
  end
    
  def after_save
    # Board.expire_cache(:startpage_announcements_of, :with => self.author)
    self.announcement.save!
  end
  
  # set Announcement attributes to Board instance methods
  begin
    Announcement.content_columns.collect(&:name).each do |attr_name|
      delegate attr_name.to_sym,       :to => :announcement
      delegate "#{attr_name}=".to_sym, :to => :announcement
      delegate "#{attr_name}?".to_sym, :to => :announcement
    end
    delegate :_reason_for_kroogi_pass, :_reason_for_kroogi_pass=, :stick_or_unstick!, :to => :announcement
  rescue ActiveRecord::StatementInvalid
    nil # For migrations, where announcement table doesn't yet exist
  end
  
  def validate
    errors.add_to_base("#{'You need to set up PayPal or Webmoney in your account in order to allow contributions!'.t}") if (show_donation_button? && !donation_account_set?)
  end
    
  def sticky?
    priority?
  end
  alias :announcement? :sticky?

  def usernote?
    !sticky?
  end

  def sticky=(value)
    self.priority = value || false
  end
  
  def add_attendee(attendee)
    self.attendees << attendee
  end
  
  def entity_name_for_human
    # 'Announcement'.t
    # 'Note'.t
    sticky? ? 'Announcement' : 'Note'
  end

  def display_type
    entity_name_for_human
  end

  def title(length = 20)
    AutoExcerpt.new(post || "", :characters => length, :strip_tags => true)
  end

  def flat_comments?
    true
  end

end
