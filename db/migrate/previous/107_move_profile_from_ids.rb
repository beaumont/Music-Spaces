class MoveProfileFromIds < ActiveRecord::Migration
  
  # this is the original profile question model that will get modified, that's why it is in here
  class ProfileQuestion < ActiveRecord::Base
    GROUPS = {:basic_user_1 => [:country, :city],
        :basic_user_2 => [:birthdate, :website, :bio, :interests, :favorite_music, :school, :occupation],
        :basic_project_1 => [:website, :about_project],
        :contact => [:skype, :yahoo, :aol, :lj, :gmail, :msn, :myspace],
        :trivia => [:qs_1, :an_1, :qs_2, :an_2, :qs_3, :an_3, :qs_4, :an_4]}
    
    QUESTION_MAP = {
        :skype =>       {:id => 0,  :name => 'Skype'},
        :yahoo =>       {:id => 1,  :name => 'Yahoo! IM'},
        :aol =>         {:id => 2,  :name => 'AOL'},
        :lj =>          {:id => 3,  :name => 'LiveJournal'},
        :gmail =>       {:id => 4,  :name => 'Google talk'},
        :msn =>         {:id => 5,  :name => 'MSN IM'},
        :myspace =>     {:id => 6,  :name => 'MySpace'},
        
        # more basic
        :birthdate =>         {:id => 66, :name => 'Birthdate'},
        :country =>         {:id => 67, :name => 'Country', :tag => true},
        :city =>         {:id => 68, :name => 'City', :tag => true},
        :occupation =>   {:id => 99, :name => 'Occupation', :tag => true},
        :website =>         {:id => 69, :name => 'Website'},
        :bio =>         {:id => 70, :name => 'About', :html => {:form => :textarea}},
        :interests =>         {:id => 71, :name => 'Interests', :html => {:form => :textarea}, :tag => true},
        :favorite_music =>         {:id => 72, :name => 'Favorite music', :html => {:form => :textarea}, :tag => true},
        :school =>         {:id => 73, :name => 'School', :html => {:size => 30}, :tag => true},
        :uknown => {:id => 74},
        :about_project => {:id => 75, :name => 'About Project', :html => {:form => :textarea}},
        

        # trivia ??
        :qs_1 =>        {:id => 7,  :name => 'Question'},
        :qs_2 =>        {:id => 8,  :name => 'Question'},
        :qs_3 =>        {:id => 9,  :name => 'Question'},
        :qs_4 =>        {:id => 10, :name => 'Question'},
        :an_1 =>        {:id => 11, :name => 'Answer', :html => {:form => :textarea}},
        :an_2 =>        {:id => 12, :name => 'Answer', :html => {:form => :textarea}},
        :an_3 =>        {:id => 13, :name => 'Answer', :html => {:form => :textarea}},
        :an_4 =>        {:id => 14, :name => 'Answer', :html => {:form => :textarea}},
        # up to 26 id is available
        # do not use ids from 26 through 87 - there were once populated by crap
    }
    
    def name
        load_by_key
        @found_arr[1][:name] || @found_arr[0].to_s
    end
    
    def key
        load_by_key
        @found_arr[0]
    end
        
    def load_by_key
      return if @found_arr
      @found_arr = ((QUESTION_MAP.find {|key_val| key_val[1][:id] == self.question_id}) || [:uknown, {:id => 74}])
    end

    # these methods just lend a helping hand  
    # turn the key into the question, or the answer into the question if it's trivia
    def get_question
      if self.key.to_s =~ /(an_)([0-9])/
         q_id = QUESTION_MAP["qs_#{$+}".to_sym][:id]
         q = ProfileQuestion.find_by_profile_id_and_question_id(self.profile_id, q_id)
         q.answer
      else
        nil
      end
    end
  
    # question_key in the db maps to QUESTION_MAP.keys instead of the ids
    def new_key_format
      if GROUPS[:trivia].include?(self.key)
        if self.key.to_s =~ /(qs_)/
          "old_question"
        else
          "trivia"
        end
      else
        self.key.to_s
      end
    end
  end
  
  
  def self.up
    transaction do
      add_column :profile_questions, :question_key, :string, :limit => 30
      add_column :profile_questions, :question, :string, :null => true
      change_column :profile_questions, :in_start, :boolean, :default => true
      rename_column :profile_questions, :in_start, :show_on_kroogi_page
      rename_column :profile_questions, :is_public, :show_on_profile
      ProfileQuestion.find(:all).each do |pq|
        # puts %{question: #{pq.get_question}\n key: #{pq.new_key_format.to_s}}
        pq.question     = pq.get_question
        pq.question_key = pq.new_key_format
        pq.save(false)
      end
    end
  end

  def self.down
    remove_column :profile_questions, :question
    remove_column :profile_questions, :question_key
    rename_column :profile_questions, :show_on_profile, :is_public
    rename_column :profile_questions, :show_on_kroogi_page, :in_start
    change_column :profile_questions, :in_start, :boolean, :default => false
  end
end
