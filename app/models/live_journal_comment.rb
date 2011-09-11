# == Schema Information
# Schema version: 20081006211752
#
# Table name: live_journal_comments
#
#  id              :integer(11)     not null, primary key
#  account_id      :integer(11)     not null
#  comment_id      :integer(11)
#  parent_id       :integer(11)
#  journal_item_id :integer(11)
#  poster_id       :integer(11)
#  state           :string(1)       default("A")
#  user            :string(255)
#  property        :string(255)
#  subject         :string(255)
#  body            :text
#  posted_at       :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

# This class provides local caching for LiveJournal comments.
# See http://www.livejournal.com/developer/exporting.bml for more information.
require 'livejournal/sync'
class LiveJournalComment < ActiveRecord::Base
  xss_terminate :except => [:body, :state]
  
  belongs_to :account
  validates_presence_of :account_id
  acts_as_tree :order => 'posted_at DESC'
  
  belongs_to :entry, :class_name => 'LiveJournalEntry', :foreign_key => 'journal_item_id'

  # Provides attribute mappings for light caching 
  # attributes => meta_methods
  META_MAPPINGS = {
    :comment_id  => :commentid,
    :poster_id   => :posterid,
    :state       => :state
  }.freeze

  # Provides attribute mappings for heavy caching
  # attributes => body_methods
  BODY_MAPPINGS = {
    :comment_id      => :commentid,
    :poster_id       => :posterid,
    :state           => :state,
    :journal_item_id => :itemid,
    :parent_id       => :parentid,
    :subject         => :subject,
    :body            => :body,
    :posted_at       => :time
  }.freeze
  
  # protected methods...

  # Update the meta data cache and the body cache for a specified account
  def self.update_cache_for(account)
    user = account.authenticate
    
    # Cache the meta data
    last_meta_comment = account.comments.last_meta
    next_meta = last_meta_comment.nil? ? 0 : last_meta_comment.comment_id + 1
    comment_sync = LiveJournal::Sync::Comments.new(user)
    comment_sync.run_metadata(next_meta) do |curr, max, data|
      data.comments.each do |id, a_comment|
        comment = account.comments.find_or_create_by_comment_id(id)
        META_MAPPINGS.each do |db_col, meta_col|
          if meta_col == :state
            comment.send(:state=, LiveJournal::Comment::state_to_string(a_comment.state))
          else
          comment.send("#{db_col}=", a_comment.send("#{meta_col}"))
          end
        end
        comment.save!
      end
    end
    
    # Cache the body data
    last_body_comment = account.comments.last_body
    next_body = last_body_comment.nil? ? 0 : last_body_comment.comment_id + 1
    comment_sync.run_body(next_body) do |curr, max, data|
      data.comments.each do |id, a_comment|
        comment = account.comments.find_by_comment_id(id)
        BODY_MAPPINGS.each do |db_col, body_col|
          if body_col == :state
            comment.send(:state=, LiveJournal::Comment::state_to_string(a_comment.state))
          else
          comment.send("#{db_col}=", a_comment.send("#{body_col}"))
          end
        end
        comment.save!
      end
    end
  end
  
  
end
