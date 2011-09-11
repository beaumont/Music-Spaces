# == Schema Information
# Schema version: 20090211222143
#
# Table name: profile_questions
#
#  id                  :integer(11)     not null, primary key
#  profile_id          :integer(11)     default(1), not null
#  user_id             :integer(11)     default(1), not null
#  position            :integer(11)
#  answer              :text
#  created_by_id       :integer(11)     default(0), not null
#  updated_by_id       :integer(11)     default(0), not null
#  created_at          :datetime        default(Thu Jan 01 00:00:00 -0800 1970), not null
#  updated_at          :datetime        default(Thu Jan 01 00:00:00 -0800 1970), not null
#  author_id           :integer(11)     default(0), not null
#  show_on_kroogi_page :boolean(1)
#  show_on_profile     :boolean(1)
#  question_key        :string(30)
#  question            :string(255)
#  answer_ru           :text
#  question_ru         :string(255)
#  answer_fr           :text
#  question_fr         :string(255)
#

class ProfileQuestion < ActiveRecord::Base
    belongs_to :profile
    acts_as_list :scope => :profile
    
    before_save :normalize_url
    xss_terminate :except => [:answer]
    
    attr_accessor :is_dirty
    
    acts_as_taggable

    translates :answer, :question, :base_as_default => true
        
    # used only for trivia questions
    def is_complete?
      self.class.globalize_facets.collect do |attrib|
        ( !send("#{attrib}_ru").blank? || !send("_#{attrib}").blank?)
      end.any?
    end
    
    def being_deleted?
      self.class.globalize_facets.all? do |attrib|
        ( send("#{attrib}_ru").blank? && send("_#{attrib}").blank?)
      end
    end
    # -------------------------------
    
    validates_presence_of :question, :message => "can't be blank", :if => proc{ |obj| obj.key == "trivia" && obj.is_complete? }
    
    GROUPS = {:basic_user_1 => %w[country city],
        :basic_user_2 => %w[website bio interests school], #, :occupation],
        :basic_project_1 => %w[website about_project interests],
        :contact => %w[skype yahoo aol lj icq gmail msn myspace]}

    QUESTION_MAP = {
        :skype =>       {:name => lambda {|q| 'Skype'.t}},
        :yahoo =>       {:name => lambda {|q| 'Yahoo! IM'.t}},
        :aol =>         {:name => lambda {|q| 'AOL'.t}},
        :lj =>          {:name => lambda {|q| 'LiveJournal'.t}},
        :gmail =>       {:name => lambda {|q| 'Google talk'.t}},
        :msn =>         {:name => lambda {|q| 'MSN IM'.t}},
        :myspace =>     {:name => lambda {|q| 'MySpace'.t}},
        :icq =>         {:name => lambda {|q| "ICQ".t}},
        # more basic
        :birthdate =>   {:name => lambda {|q| q.profile.is_person? ? 'Birth date'.t  : 'Date of formation'.t }},
        :country =>     {:name => lambda {|q| 'Country'.t}, :tag => true, :html => {:form => :dropdown}},
        :city =>        {:name => lambda {|q| 'City'.t}, :tag => true},
        :occupation =>  {:name => lambda {|q| 'Occupation'.t}, :tag => true},
        :website =>     {:name => lambda {|q| 'Website'.t}},
        :bio =>         {:name => lambda {|q| 'About'.t}, :html => {:form => :textarea}, :translated => true},
        :interests =>   {:name => lambda {|q| 'Tags'.t}, :html => {:form => :textarea}, :tag => true},
        # :favorite_music => {:name => 'Favorite music', :html => {:form => :textarea}, :tag => true},
        :school =>         {:name => lambda {|q| 'School'.t}, :html => {:size => 30}, :tag => true},
        :uknown =>         {},
        :about_project =>  {:name => lambda {|q| 'About Project'.t}, :html => {:form => :textarea}, :translated => true}  
    }.with_indifferent_access
    
    def self.group(key)
      GROUPS[key]
    end
    
    def self.key_exists?(key)
      !QUESTION_MAP[key].nil?
    end
    
    def self.mapped_key_hash(key)
      QUESTION_MAP[key] || {:name => "unknown"}
    end
    
    
    def key
      self.question_key.to_s
    end
    
    # make sure key is never stored as a symbol
    def question_key=(k)
      write_attribute("question_key", k.to_s)
    end
    
    def answer_with_tags
      is_tagged? ? profile.contextual_tag_list(self.key).join(', ') : answer_without_tags
    end
    alias_method_chain :answer, :tags
    
    
    def answer=(a)
      if self.is_tagged?
        self.profile.add_contextual_tags(a,self.question_key)
      end
      write_attribute("answer", a)
    end
    
    def show_on_kroogi_page=(n)
      n = 0 if n.blank?
      write_attribute("show_on_kroogi_page", n.to_i)
    end
    
    def is_tagged?
      mapped_key_hash[:tag] || false
    end
    
    def mapped_key_hash
      self.class.mapped_key_hash(self.question_key)
    end
    
    def name
      result = mapped_key_hash[:name]
      result = result.is_a?(Proc) ? result.call(self) : result.t
      result
    end

    def is_textarea?
      html[:form] == :textarea
    end

    def dropdown?
      html[:form] == :dropdown
    end
    
    def html
      mapped_key_hash[:html] || {}
    end
    
    def translatable?
      mapped_key_hash[:translated]
    end
    
    protected
    def normalize_url
      return if !(self.question_key == "website") || self.answer.blank?
      unless self.answer =~ /(^http\:\/\/)/
        url = "http://" + self.answer
        url.downcase!
      end
      self.answer = url || self.answer
    end
    
end
