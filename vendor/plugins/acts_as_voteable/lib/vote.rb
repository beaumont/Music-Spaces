class Vote < ActiveRecord::Base
  ERROR_MESSAGES = {
    :user => {
      :presence => ' must be associated.'
    },
    :voteable => {
      :presence => ' must be associated.'
    }
  }
  
  VALID_DIRECTIONS = [:up, :down]
  
  belongs_to :user
  belongs_to :voteable, :polymorphic => true
  
  validates_presence_of :user_id
  validates_presence_of :voteable_id
  
  before_save :set_points
  
  private
  
    def self.vote_class(direction)
      raise ArgumentError.new(
        "#{direction} is not a valid value (#{VALID_DIRECTIONS.join(', ')}) for direction in vote_class(direction)"
      ) unless valid_direction?(direction)
      (direction.to_s.camelize + "Vote").constantize
    end
  
    def self.valid_direction?(direction)
      VALID_DIRECTIONS.detect{|x| x == direction}
    end
  
end
