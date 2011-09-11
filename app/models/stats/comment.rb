# == Schema Information
# Schema version: 20081006211752
#
# Table name: comments
#
#  id               :integer(11)     not null, primary key
#  title            :string(50)      default("")
#  created_at       :datetime        not null
#  commentable_id   :integer(11)     default(0), not null
#  commentable_type :string(15)      default(""), not null
#  user_id          :integer(11)     default(0), not null
#  comments_count   :integer(11)     default(0), not null
#  parent_id        :integer(11)
#  lft              :integer(11)
#  rgt              :integer(11)
#  created_by_id    :integer(11)     default(0), not null
#  avatar_id        :integer(11)
#  db_store_id      :integer(11)
#  deleted_at       :datetime
#  deleted_by       :integer(11)
#  private          :boolean(1)
#

class Stats::Comment < Stat
end
