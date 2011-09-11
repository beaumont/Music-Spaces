#  create_table "answer_interval_counters", :force => true do |t|
#    t.column "user_id",   :integer, :null => false
#    t.column "artist_id", :integer, :null => false
#    t.column "counter",   :integer, :null => false
#  end
#
class AnswerIntervalCounter < ActiveRecord::Base
  belongs_to :user
  belongs_to :artist, :class_name => 'User'

  def self.find_or_build(user, artist)
    res = find_by_user_id_and_artist_id(user.id, artist.id)
    unless res
      res = AnswerIntervalCounter.new(:user_id => user.id, :artist_id => artist.id)
      res.reset
    end
    res
  end

  def reset(options = {})
    original_x = artist.questions_interval
    x = options[:enlarge_interval] ? original_x * 2 : original_x 
    if original_x == 1
      self.counter = x
    else
      n = artist.questions_interval_random_delta
      middle = n
      delta = rand(2 * n + 1) - middle
      self.counter = (x + delta).round
    end
    self.save! if options[:persist]
    self.counter
  end
  
  def cycle!
    self.counter -= 1
    result = self.counter
    result = 0 if result < 0
    reset if result == 0
    save!
    result
  end
end
