class AddQuestionsIntervalToUsers < ActiveRecord::Migration
  def self.up
    add_column 'rare_user_settings', 'questions_interval', :integer
    add_column 'rare_user_settings', 'questions_interval_random_delta', :integer

    create_table 'answer_interval_counters' do |t|
      t.integer :user_id, :null => false
      t.integer :artist_id, :null => false
      t.integer :counter, :null => false
    end
    add_index "answer_interval_counters", ["artist_id", 'user_id'], :unique => true
  end

  def self.down
  end
end
