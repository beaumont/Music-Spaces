#  create_table "tps_participant_info_requests", :force => true do |t|
#    t.column "participant_id",      :integer,                     :null => false
#    t.column "address_needed",      :boolean,                     :null => false
#    t.column "document_needed",     :boolean,                     :null => false
#    t.column "answered",            :boolean,  :default => false, :null => false
#    t.column "first_name",          :string
#    t.column "last_name",           :string
#    t.column "document_kind",       :string
#    t.column "document_identifier", :string
#    t.column "address",             :string
#    t.column "created_at",          :datetime
#    t.column "updated_at",          :datetime
#  end
#
module Tps
  class ParticipantInfoRequest < ActiveRecord::Base
    set_table_name 'tps_participant_info_requests'
    belongs_to :participant, :class_name => 'Tps::Participant'

    named_scope :to, lambda {|participant| { :conditions => ['participant_id = ?', participant.id]} }

    after_save :maybe_send_message

    validates_presence_of :first_name
    validates_presence_of :last_name
    validates_presence_of :address, :if => :address_needed?
    validates_presence_of :document_kind, :if => :document_needed?
    validates_presence_of :document_identifier, :if => :document_needed?

    %w(content).each do |attr_name|
      delegate attr_name.to_sym,       :to => :participant
    end

    def maybe_send_message
      if Activity.for_content(self).empty?
        Activity.send_message(self, participant.content.user, :tps_participant_info_request_sent)
      end
    end

    def save_answer
      self.answered = true
      result = self.save
      return unless result
      fields = %w(first_name last_name)
      fields << :address if address_needed
      fields += [:document_kind, :document_identifier] if document_needed
      fields.each {|f| participant.send(f.to_s + '=', self.send(f))}
      participant.reply!
      Activity.send_message(self, participant.user, :tps_participant_info_request_answered)
      result
    end
    
  end
end
