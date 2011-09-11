#  create_table "tps_participants", :force => true do |t|
#    t.column "content_id",          :integer,  :null => false
#    t.column "user_id",             :integer,  :null => false
#    t.column "first_name",          :string
#    t.column "last_name",           :string
#    t.column "document_kind",       :string
#    t.column "document_identifier", :string
#    t.column "address",             :string
#    t.column "address_missing",     :boolean
#    t.column "document_missing",    :boolean
#    t.column "state",               :string,   :null => false
#    t.column "created_at",          :datetime
#    t.column "updated_at",          :datetime
#  end
#
module Tps
  class Participant < ActiveRecord::Base
    set_table_name 'tps_participants'
    belongs_to :content
    belongs_to :user
    has_many :info_requests, :class_name => 'Tps::ParticipantInfoRequest'

    named_scope :with_contents, :joins => "JOIN contents on contents.id = tps_participants.content_id" 
    named_scope :of_project, lambda {|project| { :conditions => ['contents.user_id = ?', project.id]} }

    include AASM


    aasm_column :state
    aasm_initial_state :unfilled

    aasm_state :unfilled
    aasm_state :replied
    aasm_state :approved

    aasm_event :reply do
      transitions :from => [:unfilled, :replied], :to => :replied
    end

    aasm_event :approve do
      transitions :from => [:replied], :to => :approved      
    end

    aasm_event :deapprove do
      transitions :from => [:approved], :to => :replied      
    end

    named_scope :filled, :conditions => ['tps_participants.state != ?', 'unfilled']

    acts_as_threaded

    after_save :create_or_update_request

    def create_or_update_request(force_creating = false)
      return unless self.address_missing || self.document_missing

      request = force_creating ? nil : Tps::ParticipantInfoRequest.to(self).last
      request ||= Tps::ParticipantInfoRequest.new(:participant_id => self.id)
      request.address_needed = !!self.address_missing
      request.document_needed = !!self.document_missing
      request.save_without_validation!
    end

    def create_request
      create_or_update_request(true)
    end

    def commentable?
      true
    end
    
    def tickets
      GoodieTicket.of_buyer(user).of_hat(content)
    end

    def full_name
      first_name + ' ' + last_name
    end

    def is_view_permitted?(user)
      true
    end
    
  end
end
