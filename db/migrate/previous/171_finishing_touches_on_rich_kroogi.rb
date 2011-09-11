class FinishingTouchesOnRichKroogi < ActiveRecord::Migration
  def self.up
    # Settings for e.g. Family should be invite-only by default
    UserKroog.update_all ['open=? and can_request_invite=?', false, false], "relationshiptype_id = #{Relationshiptype::TYPES[:family]}"
    UserKroog.update_all ['open=? and can_request_invite=?', false, true], "relationshiptype_id in (2,3,4)"
    UserKroog.update_all ['open=? and can_request_invite=?', true, true], "relationshiptype_id = #{Relationshiptype::TYPES[:interested]}"

    # NOTE: THE ABOVE FAILS TO WORK, rectified in migration 172

    # Remove activity messages regarding existing get closer requests
    Activity.delete_all ['activity_count_id=?', Activity::ACTIVITIES[:sent_getcloser][:id]]

    # Remove existing get closer requests
    ActiveRecord::Base.connection.execute('UPDATE relationships SET attributebits = (attributebits & ~1) | 0 where (1 & attributebits) = 1')
  end

  def self.down
  end
end