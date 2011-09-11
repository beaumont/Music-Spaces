#  create_table "system_messages_show_triggers", :force => true do |t|
#    t.column "user_id",             :integer,                 :null => false
#    t.column "system_message_type", :string,                  :null => false
#    t.column "priority",            :integer,  :default => 0, :null => false
#    t.column "delay",               :integer
#    t.column "created_at",          :datetime
#    t.column "updated_at",          :datetime
#  end
#
module SystemMessages

  class ShowTrigger < ActiveRecord::Base
    set_table_name :system_messages_show_triggers
    belongs_to :user

    named_scope :for_user, lambda {|user| { :conditions => ['user_id = ?', user.id]} }
    named_scope :for_system_message_type, lambda {|klass| { :conditions => ['system_message_type = ?', klass.name]} }

    def system_message
      system_message_type.constantize.new
    end

    def postpone
      self.update_attribute(:show_at, Time.now + system_message.delay)
    end

    def delayed?
      not self.show_at.nil? and Time.now < self.show_at
    end

    def self.choose_trigger(for_user, controller)
      triggers = ShowTrigger.for_user(for_user)
      return if triggers.empty?

      triggers = triggers.map do |trigger|
        sm = trigger.system_message
        trigger = if sm.trigger_stale?(trigger)
          trigger.destroy
          nil
        else
          trigger
        end

        trigger = sm.trigger_accepted(trigger) if trigger && sm.accept_action?(controller)
        trigger
      end.compact

      triggers = triggers.select {|trigger| trigger.system_message.can_be_shown_here?(controller)}
      result = triggers.max {|a, b| a.priority <=> b.priority}
      (result and result.delayed?) ? nil : result
    end

    def accept
      system_message.trigger_accepted(self)
    end

    def create_denied_response
      Responses::Denied.create(response_params)
    end

    def create_postponed_response
      Responses::Postponed.create(response_params)
    end

    def create_accepted_response
      Responses::Accepted.create(response_params)
    end

    def self.maybe_create_for(user, message_class)
      conditions = {:user_id => user.id, :system_message_type => message_class.name}
      unless Responses::Denied.first(:conditions => conditions)
        self.create(conditions)
      end
    end
    
    private
    
    def response_params
      {:user_id => self.user_id, :system_message_type => self.system_message_type}
    end
  end

end
