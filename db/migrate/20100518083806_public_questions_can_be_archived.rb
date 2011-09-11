class PublicQuestionsCanBeArchived < ActiveRecord::Migration
  def self.up
    add_column 'public_questions', 'state', :string 
    remove_column 'public_questions', 'published'
    PublicQuestion.update_all "state = 'published'"
    add_index "public_questions", ["user_id", 'state']
    add_index "public_answers", ["question_id", 'deleted']
  end

  def self.down
  end
end
