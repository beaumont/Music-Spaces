#  create_table "rare_user_settings", :force => true do |t|
#    t.column "user_id",                         :integer, :null => false
#    t.column "questions_enabled",               :boolean
#    t.column "questions_interval",              :integer
#    t.column "questions_interval_random_delta", :integer
#    t.column "allows_guest_comments",           :boolean
#    t.column "fwd_tos_allowed",                 :boolean
#  end
#
class RareUserSettings < ActiveRecord::Base
  set_table_name "rare_user_settings"  
end
