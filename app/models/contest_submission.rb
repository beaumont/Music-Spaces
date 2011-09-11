#
#  t.column "content_id",    :integer
#  t.column "contest_id",    :integer
#  t.column "level",         :integer
#  t.column "created_by_id", :integer
#  t.column "updated_by_id", :integer
#  t.column "created_at",    :datetime
#  t.column "updated_at",    :datetime
#
class ContestSubmission < ActiveRecord::Base
  belongs_to :content
  
  MAX_LEVEL = 3
  def promote_level
    errors.add_to_base('The track is at the top of the contest already'.t) and return if level >= MAX_LEVEL
    self.update_attribute(:level, level + 1)
  end
end
