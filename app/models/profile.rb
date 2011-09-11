# == Schema Information
# Schema version: 20090211222143
#
# Table name: profiles
#
#  id               :integer(11)     not null, primary key
#  user_id          :integer(11)     default(1), not null
#  account_type_id  :integer(11)
#  avatar_id        :integer(11)
#  userpic_id       :integer(11)
#  wizard_completed :boolean(1)
#  tagline          :string(255)
#  tagline_ru       :string(255)
#

class Profile < ActiveRecord::Base
    
    belongs_to :user
    has_many :profile_questions, :order => "position asc", :dependent => :delete_all do
      def by_name(n)
        self.find(:first, :conditions => ['question_key=?', n])
      end
    end
    belongs_to :avatar, :class_name => "Image", :foreign_key => "avatar_id", :conditions => ["contents.state='active' and contents.cat_id=?", Content::CATEGORIES[:avatar][:id]]
    belongs_to :userpic, :class_name => "Image", :foreign_key => "userpic_id", :conditions => 'contents.state="active"'

    translates :tagline, :base_as_default => true

    acts_as_threaded
    acts_as_permitted
    acts_as_taggable
    after_save :save_question_list
    attr_accessor :question_list
    PERSON, PROJECT = 0, 1
        
    # framework callback
    def before_create
      self.account_type_id = Profile::PERSON if (self.respond_to?("account_type_id") && self.account_type_id.nil?)
    end

    def validate
      errors.add_to_base("One or more trivia questions is invalid.".t) if @trivia_errors
    end
    
    def is_view_permitted?(user_or_project = nil)
      user ? user.is_view_permitted?(user_or_project) : false
    end

    #This may look strange but new ProfileQuestions are created here, too. Though AR's docs say .build doesn't save it.
    #This is backed by profile_controller_spec.rb 
    def question_list=(questions)
      questions.each_with_index do |question_attrs, index|
        question_attrs[:question_key] = :trivia
        question_attrs[:show_on_kroogi_page] ||= 0
        question_attrs[:position] = index
        profile_question = profile_questions.find_by_id(question_attrs[:id].to_i) unless question_attrs[:id].blank?
        if question_attrs[:id].blank?
          profile_question = profile_questions.build(question_attrs)
        else
          profile_question = profile_questions.find_by_id(question_attrs[:id].to_i)
          if profile_question
            profile_question.attributes = question_attrs
          else
            #looks like .build create record here - so let's pass it through further deletion too if it's blank
            profile_question = profile_questions.build(question_attrs)
          end
        end
        if profile_question.being_deleted?
          profile_question.destroy
        else
          if validate_trivia(profile_question)
            profile_question.save! if profile_question.id #update updated child - it doesn't happen on parent's save, see #2382
          end
        end
      end
    end
    
    # manual addition of tags with a certain context
    def add_contextual_tags(context_tags, context)
      Tagging.destroy_all(:taggable_id => self.id, :taggable_type => "Profile", :context => context) # destroy old taggings
      unless context_tags.nil?
        context_tags.split(",").slice(0...10).each do |tag|
          context_tag = Tag.find_or_create_with_like_by_name(tag.clean)
          taggings << Tagging.create(:tag_id => context_tag.id, :context => context)
        end
      end 
    end

    # get tags of a certain type
    # TODO allow normal #find options
    def find_contextual_tags(context)
      tags.find(:all, :conditions => { 'taggings.context' => context})
    end
    
    def contextual_tag_list(context = ProfileQuestion::QUESTION_MAP.collect{ |k,v| k.to_s if v[:tag] }.compact)
      if c_tags = find_contextual_tags(context)
        c_tags.collect(&:name)
      else
        []
      end
    end

    def city_and_country
      [city_value, country_value].delete_if(&:blank?).join(', ') 
    end
    
    def date_of_birth_pretty=(date)
      birthdate(date)# unless date.blank?
    end

    def date_of_birth_pretty
        begin
            self.birthdate.to_date.localize("%d %B %Y")
        rescue
            self.birthdate
        end
    end
    
    def birthdate_before_type_cast
        self.birthdate
    end
    
    def is_person?
      self.account_type_id == PERSON
    end

    
    def avatars
      @avatars ||= self.user.contents.avatars.limit(25)
    end

    # find/sort questions in groups
    def question_group(group_name, include_empties = true, filter = {})
      question_set = []
      # grab existing questions
      existing_questions = profile_questions.find_all_by_question_key(ProfileQuestion.group(group_name))
      ProfileQuestion.group(group_name).each do |key|
        # method to call if question doesn't exist
        add_new_question = lambda { profile_questions.build(:question_key => key) if include_empties }
        # grab old question or create new one.
        eq = existing_questions.detect(add_new_question){|pq| pq.question_key == key }
        question_set << eq if (filter.empty? || eq && filter[:start])
      end
      # remove nil entries and return array
      question_set.compact
    end
    
    def trivia_group(upto = 3)
      trivia = trivia_questions
      trivia.length.upto(upto){|triv| trivia << profile_questions.build(:question_key => "trivia") }
      trivia
    end
    
    def question_object(key_name, create_new = false)
      self.profile_questions.find_by_question_key(key_name.to_s) || (self.profile_questions.build(:question_key => key_name) if create_new)
    end
    
    def trivia_questions(options = {})
      opts = options.merge({:question_key => "trivia"})
      profile_questions.find(:all, :conditions => opts)
    end    
    
    ProfileQuestion::QUESTION_MAP.each_key do |k|
      class_eval <<-RUBY, "__(PROFILE_#{k.to_s.upcase})__", __LINE__ +1
        attr_accessor :#{k}
        def #{k}_value; question_object(:#{k}).try(:answer); end
        def #{k}; question_object(:#{k},true); end
        def #{k}=(val)
          # val = v.last.is_a?(Hash) ? v.pop : v.first
          obj = question_object(:#{k},true)
          unless obj.new_record?
            profile_questions.delete(obj)
            obj = profile_questions.build(:question_key => :#{k})
          end
          
          if val.is_a?(Hash)
            obj.attributes = val
            obj.save!
          else
            obj.update_attribute(:answer, val)
          end
          obj.reload
          obj
        end
      RUBY
    end

    def host_user
      user
    end

    def flat_comments?
      false
    end

    def commentable?
      true
    end

    def about_us
      q = profile_questions.find_by_question_key('bio')
      q ? q.answer : nil
    end
    
    protected
    
    def validate_trivia(pq)
      if pq.valid? && !pq.being_deleted?
        true
      else
        @trivia_errors = true
        false
      end
    end
    
    def save_question_list
      self.trivia_questions.each do |pq|
        pq.save! unless pq.frozen?
      end
      true
    end
    
end
