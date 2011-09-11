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

class Inbox < Album
  has_one :extra_fieldset, :class_name => 'ExtraFieldset::Inbox'
  has_one :cover_art, :foreign_key => 'downloadable_album_id', :conditions => 'type="CoverArt"'
  
  has_many :inbox_contents, :class_name => "Content", 
    :finder_sql => 'SELECT contents.* FROM contents INNER JOIN inbox_items ON contents.id = inbox_items.content_id WHERE (inbox_items.inbox_id = #{id}) order by position desc'
  
  has_many :inbox_items, :foreign_key => 'inbox_id', :order => 'position'

  def album_contents
    inbox_contents
  end
  
  # Ensure Inbox object always has an extra fieldset laying around for the delegated methods
  # NOTE: DO NOT CHANGE THIS TO AFTER CREATE -- will no longer be able to create inboxes through the UI
  def after_initialize
    self.build_extra_fieldset unless self.extra_fieldset
  end

  def after_save
    extra_fieldset.save if extra_fieldset.changed?
  end

  # images tracks videos writings archived feature_most_recent tagline tagline_ru tagline_fr
  (ExtraFieldset::Inbox.column_names - %w(id inbox_id created_at updated_at)).each do |attr_name|
    delegate attr_name, "#{attr_name}?", "#{attr_name}=", :to => :extra_fieldset
  end
  delegate "_tagline", "_tagline=", "_tagline?", :to => :extra_fieldset
  
  # Can the given content item be added to this inbox?
  def accepts?(content)
    return false unless content && content.public?
    
    case content.class.to_s
    when 'Image' then images?
    when 'Track' then tracks?
    when 'Video' then videos?
    when 'Textentry' then content.cat_id == Content::CATEGORIES[:writing][:id]
    else false
    end
  end

  # Used to build a default album whenever a new user is created
  def self.create_default_for(user)
    Content.without_monitoring do
      box = Inbox.new
      box.attributes = {
        :user_id => user.id,
        :title => "Submitted to #{user.login}",
        :title_ru => "Прислано для #{user.login}",
        :tagline => "Submit content from your Kroogi to #{user.login}",
        :tagline_ru => "Отправьте материалы для #{user.login} со своей страницы",
        :cat_id => Content::CATEGORIES[:inbox][:id],
        :created_by_id => user.id,
        :is_in_gallery => false,
        :relationshiptype_id => 5,
      }
      box.save!
    end
  end
  
  # We don't have album items... this is used by normal albums to check if they should be allowed into other, non-public albums
  def album_item_in_inbox?
    false
  end

  # returns the connecting inbox_item 
  def get_connector(content)
    InboxItem.find(:first, :conditions => {:content_id => content.id, :inbox_id => self.id})
  end

  def images
    @images ||= inbox_contents.select {|x| x.is_a? Image}
  end

  def last_added
    Time.parse(Content.find_by_sql("SELECT contents.*, inbox_items.created_at AS last_added_date FROM contents INNER JOIN inbox_items ON contents.id = inbox_items.content_id WHERE (inbox_items.inbox_id = #{id}) ORDER BY inbox_items.created_at DESC LIMIT 1").first.last_added_date)
  end
  
  def empty!
    inbox_items.each{|x| x.destroy}
  end

  def empty?
    inbox_items.empty?
  end
  
  # Logic to figure out if the specified user is allowed to vote for the given content item in this inbox
  def can_vote?(user, content)
    # No Voting
    return false unless allow_voting?

    # Only me voting
    return false if voting_restriction == -1 && !user == self.user

    # Unless public voting, make sure user is in qualified circle
    unless allow_voting_for_all?
      valid_circles = Relationshiptype.circle_and_closer(voting_restriction)
      return false unless self.user == user ||
              self.user.followers_and_founders.in_circles(valid_circles).count(:conditions => ['related_user_id = ?', user.id]) > 0
    end

    # Owner of content (or content creator's project owners, if applicable) can't vote for their own item
    if user.is_self_or_owner?(content.user)
      return false
    end
    
    return true
  end

  def allow_voting?
    voting_restriction > -3
  end
  
  def allow_voting_for_all?
    voting_restriction == -2
  end


  def self.voting_menu(user)
    types = user.circles(:just_ids => true)
    types.push user.project? ? Relationshiptype.founders : Relationshiptype.nobody
    types << Relationshiptype.everyone

    menuobj = Relationshiptype.find(:all, :conditions => {:id => types}, :order => 'position asc')

    menu = menuobj.collect do |item| 
      circ_name = item.id > (user.project? ? 0 : 1) ? ('%s and closer' / user.circle_name(item.id)) : user.generic_circle_name(item.id, :use_i => true)
      circ_name = 'Only hosts'.t if item.id == 0
      [("%s can vote" / [circ_name]), item.id]
    end
    menu.unshift(['Do not allow voting'.t, -3])
  end
  
  def contains_user?(user)
    inbox_contents.select{|c| c.is_a?(ProjectAsContent) && c.body_project_id == user.id}.first
  end
  
  def player_embeddable?
    false
  end

  def navigation_within_parent(parent_id)
    # For inboxes, only page between other inboxes
    Album.navigation(self, :what_we_are_iterating_over => self.user.inboxes)
  end

  def action_cache_key_suffix(controller)
    super(controller) + [controller.params[:page] || 1, controller.getpagesize]    
  end
end
