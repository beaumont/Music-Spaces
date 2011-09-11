#
#  create_table "announcements", :force => true do |t|
#    t.column "board_id",                      :integer
#    t.column "created_at",                    :datetime
#    t.column "updated_at",                    :datetime
#    t.column "generate_donor_coupons",        :boolean,  :default => false
#    t.column "require_minimum_to_get_coupon", :boolean,  :default => true
#    t.column "coupon_expiration_date",        :date
#    t.column "max_coupons",                   :integer
#    t.column "priority",                      :boolean,  :default => false, :null => false
#    t.column "reason_for_kroogi_pass",        :text
#    t.column "reason_for_kroogi_pass_ru",     :text
#    t.column "reason_for_kroogi_pass_fr",     :text
#  end
#
# TODO: rename this class (and table) to AnnouncementDetails
class Announcement < ActiveRecord::Base
  belongs_to :board
  
  attr_accessible *content_columns.collect{|cc| cc.name.to_sym}
  
  translates :reason_for_kroogi_pass
  
  def stick_or_unstick!
    self.toggle!(:priority)
  end

  def before_save
    log.debug "hello from before_save"
    super
    log.debug "super passed"
    changed = changes['priority']
    log.debug "changed = #{changed}"
    if changed
      from_type_id, to_type_id = (changed[1] ? [:published_usernote, :published_announcement] :  [:published_announcement, :published_usernote]).
              map {|key| Activity::ACTIVITIES[key][:id]}
      Activity.update_all ['activity_type_id = ?', to_type_id], ['content_type = ? AND content_id = ? AND activity_type_id = ?', 'Content', board.id, from_type_id]
    end
    log.debug "bye from before_save"
  end
    
end
