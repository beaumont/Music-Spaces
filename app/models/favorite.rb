# == Schema Information
# Schema version: 20081006211752
#
# Table name: favorites
#
#  id             :integer(11)     not null, primary key
#  user_id        :integer(11)
#  favorable_type :string(30)
#  favorable_id   :integer(11)
#  created_at     :datetime
#  updated_at     :datetime
#  created_by_id  :integer(11)     default(0), not null
#

# Defines named favorites for users that may be applied to objects in a polymorphic fashion.
class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :favorable, :polymorphic => true

  # Manage Stats
  def after_create
    if self.favorable.kind_of? Content
      ContentStat.mark_async(:favorited!, {:content => self.favorable, :user_id => self.user_id})
    end
  end
  
  def before_destroy
    if self.favorable.kind_of? Content
      ContentStat.mark_async(:defavorited!, {:content_type => self.favorable_type, :content_id => self.favorable_id, :user_id => self.user_id})
    end
  end

end
