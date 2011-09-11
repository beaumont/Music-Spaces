class AddSentFromToFeedbacks < ActiveRecord::Migration
  def self.up
    add_column :feedbacks, :sent_from, :string
    Feedback.find(:all).each do |f|
      hash = eval(f.environment)
      f.sent_from = hash['HTTP_REFERER']
      f.save!
    end
  end

  def self.down
    remove_column :feedbacks, :sent_from
  end
end
