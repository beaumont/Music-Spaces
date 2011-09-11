class AlterPublicAnswerColumns < ActiveRecord::Migration
  def self.up
    add_column 'public_answers', 'avatar_id', :integer
    add_column 'public_answers', 'deleted', :boolean, :default => 0
    rename_column 'public_answers', 'public_question_id', 'question_id'  
    remove_column 'public_answers', 'published'  
  end

  def self.down
  end
end
