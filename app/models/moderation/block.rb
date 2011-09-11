# == Schema Information
# Schema version: 20090211222143
#
# Table name: moderation_events
#
#  id              :integer(11)     not null, primary key
#  user_id         :integer(11)
#  type            :string(255)
#  message         :text
#  reportable_type :string(255)
#  reportable_id   :integer(11)
#  flag_type       :integer(11)     default(0)
#  created_at      :datetime
#  updated_at      :datetime
#  reason          :string(255)
#

# == Schema Information
# Schema version: 20081224151519
#
# Table name: moderation_events
#
#  id              :integer(11)     not null, primary key
#  user_id         :integer(11)
#  type            :string(255)
#  message         :text
#  reportable_type :string(255)
#  reportable_id   :integer(11)
#  flag_type       :integer(11)     default(0)
#  created_at      :datetime
#  updated_at      :datetime
#  reason          :string(255)
#

class Moderation::Block < Moderation::Event
  alias_method :blocker, :user
  alias_method :blockable, :reportable
  
  after_create :block_the_item

  def kind
    'Blocked'.t
  end
  
  # Return true if the item is currently blocked with a moderation event
  # (e.g. if not, may be content item blocked because user was blocked)
  def self.currently_blocked_individually?(item)
    # Has it been blocked?
    bpossibles = Moderation::Block.find(:all, :conditions => {:reportable_id => item.id})
    bfound = if item.is_a?(Content)
      bpossibles.select{|x| x.reportable_type == item.class.name || x.reportable_type == 'Content'}
    elsif item.is_a?(User)
      bpossibles.select{|x| x.reportable_type == item.class.name || x.reportable_type == 'User'}
    end
    return false if bfound.blank?
    
    # OK, so it was blocked.  Has it been restored?
    rpossibles = Moderation::Restore.find(:all, :conditions => {:reportable_id => item.id})
    rfound = if item.is_a?(Content)
      rpossibles.select{|x| x.reportable_type == item.class.name || x.reportable_type == 'Content'}
    elsif item.is_a?(User)
      rpossibles.select{|x| x.reportable_type == item.class.name || x.reportable_type == 'User'}
    end
    return true if rfound.blank?
    
    # OK, so it has been blocked AND restored.  Was the most recent action a block or a restore?
    events = bpossibles + rpossibles
    return events.sort_by(&:created_at).last.is_a?(Moderation::Block)
  end
  
  
  protected
  
  def validate
    if blockable.is_a?(User)
      errors.add_to_base('Details cannot be blank'.t) if self.message.blank?
    end
  end
  
  def block_the_item
    return unless blockable.is_a?(User) || blockable.is_a?(Content)
    blockable.block!
    send_block_message
  end
  
  # Email for user or project, pvtmessage for content
  def send_block_message
    # Create the activity message
    if blockable.is_a?(User)
      Activity.send_message(self, User.kroogi, :account_blocked)
    elsif blockable.is_a?(Content)
      Activity.send_message(self, User.kroogi, :content_blocked)
    end
    
    if blockable.instance_of?(Project)
      blockable.founders.each {|f| UserNotifier.enq_deliver_account_blocked(f, blockable) }
    elsif blockable.is_a?(User)
      UserNotifier.async_deliver_account_blocked(blockable)
    else
      msg_title = 'Your content item "%s" has been blocked' / [blockable.title_long]

      msg_txt = []
      msg_txt << "<p><strong>#{'Reason'.t}:</strong> <em>#{self.display_reason}</em></p>" unless self.display_reason.blank?
      msg_txt << "<p><strong>#{'Details'.t}:</strong> <em>#{self.message}</em></p>" unless self.message.blank?
      msg_txt = msg_txt.join

      msg = Pvtmessage.create({
        :foruser_id => responsible_user.id,
        :user_id => User.kroogi.id,
        :title => msg_title,
        :post => msg_txt})
      Activity.send_message(msg, User.kroogi, :sent_pvtmsg)
    end
  end
  
end
