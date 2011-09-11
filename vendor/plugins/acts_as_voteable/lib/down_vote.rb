class DownVote < Vote
  after_create :remove_up_vote
  
  private
  
    def set_points
      self.points = -1
    end
  
  
    def remove_up_vote
      if up_vote = user.voted_up?(voteable, :about => about)
        up_vote.destroy
      end
    end
  
end
