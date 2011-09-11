#  create_table "tps_goodies", :force => true do |t|
#    t.column "content_id",            :integer,                                                    :null => false
#    t.column "identifier",            :integer,                                                    :null => false
#    t.column "title",                 :string
#    t.column "title_ru",              :string
#    t.column "price",                 :decimal,  :precision => 10, :scale => 2, :default => 0.0
#    t.column "left",                  :integer
#    t.column "created_at",            :datetime
#    t.column "updated_at",            :datetime
#    t.column "donation",              :boolean,                                 :default => false, :null => false
#    t.column "downloadable_album_id", :integer
#    t.column "needs_document",        :boolean,                                 :default => false, :null => false
#    t.column "needs_address",         :boolean,                                 :default => false, :null => false
#  end
#
module Tps
  class Goodie < ActiveRecord::Base

    GOODIES_DELIVERY_METHOD = {
      'A' => "Participant’s full name and address",
      'B' => "Participant’s full name and identification document",
      'C' => "N/A"
    }

    set_table_name 'tps_goodies'
    translates :title, :base_as_default => true

    belongs_to :content
    belongs_to :downloadable_album, :class_name => 'Album'

    named_scope :available, :conditions => '`left` > 0 OR `left` is null'
    named_scope :of_content, lambda {|content| { :conditions => ['content_id = ?', content.id]} }
    named_scope :with_contents, :joins => "JOIN contents on contents.id = tps_goodies.content_id" 
    named_scope :of_project, lambda {|project| { :conditions => ['contents.user_id = ?', project.id]} }
    named_scope :non_tps, :conditions => ['contents.type != ?', 'Tps::Content']

    def all_gone?
      left && left <= 0
    end

    def downloadable?
      downloadable_album_id
    end

    def self.payments(for_artist)
      @payments = MonetaryDonation.find(:all, :conditions =>
              ['content_type = ? and receiver_account_setting_id = ?', GoodieTicket.name, for_artist.account_setting.id])
    end
  end
end