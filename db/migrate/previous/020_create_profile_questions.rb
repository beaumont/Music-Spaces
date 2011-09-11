class CreateProfileQuestions < ActiveRecord::Migration
  def self.up
    create_table :profile_questions , :options => 'TYPE=MyISAM', :force => true do |t|
      t.column :profile_id,                   :integer, :default => 1, :null => false
      t.column :user_id,                      :integer, :default => 1, :null => false
      t.column :question_id,                  :integer
      t.column :position,                     :integer
      t.column :answer,                       :integer
    end
  end

  def self.down
    drop_table :profile_questions
  end
end
