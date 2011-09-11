class AlterPublicQaTextColumn < ActiveRecord::Migration
  def self.up
    change_column 'public_questions', :text, :text
    change_column 'public_answers', :text, :text
  end

  def self.down
  end
end
