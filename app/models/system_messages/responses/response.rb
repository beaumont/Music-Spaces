#  create_table "system_messages_responses", :force => true do |t|
#    t.column "type",                :string
#    t.column "user_id",             :integer,  :null => false
#    t.column "system_message_type", :string,   :null => false
#    t.column "created_at",          :datetime
#    t.column "updated_at",          :datetime
#  end
#
module SystemMessages
  module Responses

    class Response < ActiveRecord::Base
      set_table_name :system_messages_responses
    end

  end
end
