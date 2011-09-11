class AddPositionToQuestions < ActiveRecord::Migration
  def self.up
    add_column 'public_questions', 'position', :integer    
  end

  def self.down
  end
end
