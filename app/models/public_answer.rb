#  create_table "public_answers", :force => true do |t|
#    t.column "question_id",   :integer,                     :null => false
#    t.column "user_id",       :integer,                     :null => false
#    t.column "text",          :text
#    t.column "created_at",    :datetime
#    t.column "updated_at",    :datetime
#    t.column "created_by_id", :integer
#    t.column "updated_by_id", :integer
#    t.column "avatar_id",     :integer
#    t.column "deleted",       :boolean,  :default => false
#  end
#
class PublicAnswer < ActiveRecord::Base
  belongs_to :question, :class_name => 'PublicQuestion'
  belongs_to :user

  #acts_as_rated :with_stats_table => true, :stats_class => 'RatingStat', :rating_range => 1..5, :no_rater => true
  acts_as_voteable
  acts_as_threaded

  named_scope :active, {:conditions => ['deleted = 0']}

  after_create :create_activity

  def can_see?
    true
  end

  def can_delete?
    return true if current_actor.moderator?
    return true if current_user.is_self_or_owner?(self.question.user)
    return true if current_user.is_self_or_owner?(self.user)
    return false
  end

  def head_of_thread?
    false
  end

  def is_view_permitted?(user = nil)
    true
  end

  def entity_name_for_human
    'Answer'.t
  end

  def title_short(howlong = 14)
    AutoExcerpt.new(text, :characters => howlong)
  end

  def title_long
    title_short(200)
  end
  alias :title :title_long

  def post
    text
  end

  def tag_list
    []
  end

  def destroy
    #before_destory doesn't work here
    clean_associated_models
    update_attribute(:deleted, true)
  end

  def clean_associated_models
    # Remove comments
    Comment.belonging_to(self).each{|c| c.destroy}

    # Remove activities
    Activity.for_content(self).delete_all
  end

  def create_activity
    kind = user.is_self_or_owner?(question.user) ? :author_answered_his_question : :published_answer
    Activity.send_message(self, user, kind)
  end

  def to_artist
    question.user
  end

  alias :host_user :to_artist
  
  def flat_comments?
    true
  end

  def display_type
    'Answer'
  end
  
end