class UpdateCircleDefaultsAgain < ActiveRecord::Migration
  def self.up
    # Settings for e.g. Family should be invite-only by default
    UserKroog.update_all 'open=0, can_request_invite=0', "relationshiptype_id = #{Relationshiptype::TYPES[:family]}"
    UserKroog.update_all 'open=0, can_request_invite=1', "relationshiptype_id in (2,3,4)"
    UserKroog.update_all 'open=1, can_request_invite=1', "relationshiptype_id = #{Relationshiptype::TYPES[:interested]}"
  end

  def self.down
  end
end
