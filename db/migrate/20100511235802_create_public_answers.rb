class CreatePublicAnswers < ActiveRecord::Migration
  def self.up
    create_table :public_answers, :force => true do |t|
      t.integer :public_question_id, :null => false
      t.integer :user_id, :null => false
      t.column :text, :string, :default => ""
      t.boolean :published, :default => 0
      t.timestamps
    end
  end

  def self.down
  end
end
