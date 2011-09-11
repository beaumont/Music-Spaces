class ChangeProfileQuestionsIndices < ActiveRecord::Migration
  def self.up
    unless RAILS_ENV == 'production' #alreeady there
      #what's actually needed
      add_index "profile_questions", [:profile_id, :question_key, :position], :name => "index_profile_questions_on_profile_id_and_question_and_position"

      #these are not needed now
      remove_index "profile_questions", :name => "index_profile_questions_on_profile_id_and_position"
      remove_index "profile_questions", :name => "index_profile_questions_on_profile_id_and_question_key"
    end


  end

  def self.down
  end
end
