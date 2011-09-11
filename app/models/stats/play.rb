# == Schema Information
# Schema version: 20081006211752
#
# Table name: stats
#
#  id           :integer(11)     not null, primary key
#  content_id   :integer(11)
#  user_id      :integer(11)
#  type         :string(255)
#  value        :string(255)
#  ip           :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  content_type :string(20)
#

class Stats::Play < Stat

  # Songs only record one "play" in the time it takes to play the track (*1.5). Not perfect, but a step in the right direction for 95 minute dj tracks
  def self.session_time_limit(opts = {})
    content = opts[:content]
    [SESSION_LENGTH, (content ? (content.length.to_i.seconds * 1.5) : nil)].compact.max
  end
  
end
