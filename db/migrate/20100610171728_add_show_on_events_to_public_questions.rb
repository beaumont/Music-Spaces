class AddShowOnEventsToPublicQuestions < ActiveRecord::Migration
  def self.up
    add_column :public_questions, :show_on_events, :boolean
    PublicQuestion.update_all('show_on_events = 1')
    change_column :public_questions, :show_on_events, :boolean, :null => false, :default => false
  end

  def self.down
  end
end
