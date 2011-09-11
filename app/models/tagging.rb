# == Schema Information
# Schema version: 20081006211752
#
# Table name: taggings
#
#  id            :integer(11)     not null, primary key
#  tag_id        :integer(11)
#  taggable_id   :integer(11)
#  taggable_type :string(255)
#  created_at    :datetime
#  created_by_id :integer(11)     default(0), not null
#  context       :string(255)
#

class Tagging < ActiveRecord::Base #:nodoc:
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true
  
  def after_destroy
    if Tag.destroy_unused and tag.taggings.count.zero?
      tag.destroy
    end
  end
end
