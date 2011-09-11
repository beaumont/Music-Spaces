# == Schema Information
# Schema version: 20090211222143
#
# Table name: inbox_items
#
#  id                     :integer(11)     not null, primary key
#  inbox_id               :integer(11)
#  content_id             :integer(11)
#  position               :integer(11)     default(0)
#  created_by_id          :integer(11)
#  created_at             :datetime
#  updated_at             :datetime
#  allow_take_to_showcase :boolean(1)      default(TRUE)
#

class InboxItem < ActiveRecord::Base
  
  belongs_to :inbox
  belongs_to :content
  belongs_to :submitter, :class_name => 'User', :foreign_key => 'user_id'
  
  acts_as_list :scope => :inbox
  acts_as_voteable

  def validate
    if APP_CONFIG.restricted_inbox && inbox_id == APP_CONFIG.restricted_inbox[0]
      if submitter.followers_count_sum.to_i < APP_CONFIG.restricted_inbox[1]
        self.errors.add_to_base("Sorry, according to the contest terms you need at least {{count}} Kroogi followers to submit content here. Invite your friends to follow you on Kroogi <a href=\"{{link}}\">here</a>." /
                [APP_CONFIG.restricted_inbox[1], "http://#{submitter.login}.#{APP_CONFIG.hostname}/invite/find/#{submitter.id}"])
      end
    end
  end

  def self.clean_duplicates!
    dups = InboxItem.find_by_sql('select inbox_id, content_id, COUNT(id) as dup_count from inbox_items group by inbox_id, content_id having dup_count > 1')
    # For each inbox_item with duplicate parts
    dups.each do |dup|
      # Cycle through all duplicates, deleting all but the first
      InboxItem.find(:all, :conditions => {:inbox_id => dup.inbox_id, :content_id => dup.content_id}).each_with_index do |item, index|
        next if index.zero?
        item.destroy
      end
    end
    dups.size
  end

  def levels_can_see
    Relationshiptype.followers_and_founders_types    
  end
end
