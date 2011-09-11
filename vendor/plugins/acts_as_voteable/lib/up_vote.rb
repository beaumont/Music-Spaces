class UpVote < Vote
  after_create :remove_down_vote

  private
  
    def set_points
      self.points = 1
    end
  
    def remove_down_vote
      if down_vote = user.voted_down?(voteable, :about => about)
        down_vote.destroy 
      end
    end
end