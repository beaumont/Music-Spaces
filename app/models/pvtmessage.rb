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

class Pvtmessage < Textentry
  
  belongs_to :foruser, :class_name => 'User'
  validates_presence_of :post
  
  named_scope :between, lambda {|peer1, peer2| {:conditions => ['foruser_id = ? AND user_id = ? OR foruser_id = ? AND user_id = ?',
                                                                peer1.id, peer2.id, peer2.id, peer1.id]} }

  def post
    return nil unless self.post_db_store
    self.post_db_store.content
  end
  
  def post=(p)
    store = self.post_db_store
    if store.nil?
      new_store = DbStore.create(:content => p)
      self.post_db_store_id = new_store.id
    else
      store.update_attribute(:content, p)
    end
  end
  
  def public
    false
  end

  #Sends message with pre-filled data from form: foruser_id, 
  def send!(actor)
    User.find(self.foruser_id) # just to crash and burn if recipient is invalid
    Content.transaction do
      self.user_id = actor.id
      self.is_in_gallery = false
      self.is_in_startpage = false
      self.cat_id = Content::CATEGORIES[:pvtmsg][:id]
      self.relationshiptype_id = Relationshiptype.nobody
      save!
      Activity.send_message(self, actor, :sent_pvtmsg)
    end
  end

  def me(current_user = self.current_user)
    return recipient if current_user.is_self_or_owner?(recipient)
    return user if current_user.is_self_or_owner?(user)
    nil
  end

  def not_me(current_user = self.current_user)
    me(current_user) == recipient ? user : recipient
  end
  
end
