#  create_table "tps_content_details", :force => true do |t|
#    t.column "content_id",           :integer,                                                  :null => false
#    t.column "short_description",    :string
#    t.column "short_description_ru", :string
#    t.column "end_date",             :date
#    t.column "related_content_id",   :integer
#    t.column "participated_count",   :integer
#    t.column "goal_amount",          :decimal,  :precision => 10, :scale => 2, :default => 0.0
#    t.column "currently_collected",  :decimal,  :precision => 10, :scale => 2, :default => 0.0
#    t.column "created_at",           :datetime
#    t.column "updated_at",           :datetime
#  end
#
module Tps
  class ContentDetails < ActiveRecord::Base
    set_table_name 'tps_content_details'
    translates :short_description, :base_as_default => true
    translates :goodies_delivery_description, :base_as_default => true
    belongs_to :content, :class_name => 'Tps::Content' 
    belongs_to :related_content, :class_name => 'Album'

    %w(user).each do |attr_name|
      delegate attr_name.to_sym,       :to => :content
    end

    def current_collected_percents
      return calc_percents(currently_collected, goal_amount, 1)
    end

    def calc_percents(currently_collected, goal_amount, step)
      max = 100.0 / step
      goal_amount = (goal_amount.to_i == 0) ? 1 : goal_amount
      value = (currently_collected / goal_amount) * max
      (value.round == max.round ? value.floor : value.round) * step
    end

    def current_collected_percents_to5
      x = calc_percents(currently_collected, goal_amount, 5)
      x = 100 if x > 100
      x
    end

    alias :artist :user

    def inc_participated_count
      update_attribute(:participated_count, participated_count + 1)
    end
    
    def dec_participated_count
      update_attribute(:participated_count, participated_count - 1)
    end

    def increase_collected(amount)
      update_attribute(:currently_collected, currently_collected + amount)      
    end

  end
end
