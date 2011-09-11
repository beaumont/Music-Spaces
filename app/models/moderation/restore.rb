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

class Moderation::Restore < Moderation::Event
  alias_method :restorer, :user
  alias_method :restorable, :reportable
  
  after_create :unblock_the_item
  
  def kind
    'Restored'.t
  end
  
  
  protected
  
  def unblock_the_item    
    return unless restorable.is_a?(User) || restorable.is_a?(Content)
    restorable.restore!
    send_restore_message
  end
  
  # Email for user or project, pvtmessage for content
  def send_restore_message
    # Create the activity message
    if restorable.is_a?(User)
      Activity.send_message(self, User.kroogi, :account_restored)
    elsif restorable.is_a?(Content)
      Activity.send_message(self, User.kroogi, :content_restored)
    end
    
    if restorable.instance_of?(Project)
      restorable.founders.each {|f| UserNotifier.enq_deliver_account_restored(f, restorable) }
    elsif restorable.is_a?(User)
      UserNotifier.async_deliver_account_restored(restorable)
    else
      msg_title = 'Your content item "%s" has been restored' / [restorable.title_long]
      msg_txt = "<p><strong>#{'Details'.t}:</strong> <em>#{self.message}</em></p>"

      msg = Pvtmessage.create({
        :foruser_id => responsible_user.id,
        :user_id => User.kroogi.id,
        :title => msg_title,
        :post => msg_txt})
      Activity.send_message(msg, User.kroogi, :sent_pvtmsg)
    end
  end
  
end
