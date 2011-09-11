#  create_table "public_questions", :force => true do |t|
#    t.column "user_id",        :integer,                     :null => false
#    t.column "text",           :text
#    t.column "created_at",     :datetime
#    t.column "updated_at",     :datetime
#    t.column "text_ru",        :text
#    t.column "created_by_id",  :integer
#    t.column "updated_by_id",  :integer
#    t.column "state",          :string
#    t.column "position",       :integer
#    t.column "show_on_events", :boolean,  :default => false, :null => false
#  end
#  
class PublicQuestion < ActiveRecord::Base
  DEFAULT_INTERVAL = 5
  DEFAULT_INTERVAL_RANDOM_DELTA = 2
  
  belongs_to :user

  named_scope :by_position,   { :order => 'position, created_at DESC'}
  named_scope :by_date,   { :order => 'created_at DESC'}
  named_scope :published,   { :conditions => ['state = ?', 'published']}
  named_scope :unpublished, { :conditions => ['state = ?', 'unpublished']}
  named_scope :archived,    { :conditions => ['state = ?', 'archived']}
  named_scope :published_and_archived,    { :conditions => ['state in (?)', ['published', 'archived']]}
  named_scope :with_user,   lambda {|who| { :conditions => ['public_questions.user_id = ?', who.id]} }
  named_scope :interactive_for, lambda { |who| {
          :joins => "LEFT OUTER JOIN public_answers on public_answers.question_id = public_questions.id AND !public_answers.deleted AND public_answers.user_id = #{who.id}",
          :conditions => "public_answers.user_id is null AND public_questions.show_on_events"

  }}
  named_scope :untouched, :conditions => {:created_by_id => nil, :updated_by_id => nil}

  has_many :answers, :class_name => 'PublicAnswer', :foreign_key => 'question_id', :conditions => '!deleted', :dependent => :destroy
  
  #acts_as_rated :with_stats_table => true, :stats_class => 'RatingStat', :rating_range => 1..5, :no_rater => true
  acts_as_voteable
  acts_as_threaded

  translates :text, :base_as_default => true

  include AASM
  aasm_column :state
  aasm_initial_state :unpublished
  aasm_state :unpublished
  aasm_state :published, :enter => :after_publishing
  aasm_state :archived

  aasm_event :publish do
    transitions :from => [:unpublished, :archived], :to => :published
  end

  aasm_event :archive do
    transitions :from => :published, :to => :archived
  end

  def is_view_permitted?(user = nil)
    true
  end

  def action_cache_key_suffix(controller)
    [updated_at.to_i, comment_count]
  end

  def post
    text
  end

  def after_publishing
    #no need to remove activities after archiving - Q is still visible with the same URL
    Activity.send_message(self, user, :published_question)
  end

  def title_short(howlong = 14)
    AutoExcerpt.new(text, :characters => howlong)
  end

  def title_long
    title_short(70)
  end
  alias :title :title_long

  def tag_list
    []
  end

  def self.choose_random(questions)
    questions[rand(questions.size)]
  end

  def find_answer_page(answer, pagesize, order)
    done = false
    i = 1
    while !done
      page = self.answers.paginate(:page => i, :per_page => pagesize, :order => order)
      return i if page.include?(answer)
      i += 1
      done = (page.size < pagesize)
    end
    nil
  end
  
end