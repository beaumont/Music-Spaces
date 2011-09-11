#
#  create_table "contribution_settings", :force => true do |t|
#    t.column "content_id",         :integer,                                :null => false
#    t.column "min_amount",         :decimal, :precision => 10, :scale => 2
#    t.column "recommended_amount", :decimal, :precision => 10, :scale => 2
#  end
#
class ContributionSetting < ActiveRecord::Base

  def amount
    return @amount if defined?(@amount)
    min_amount || recommended_amount 
  end

  def amount=(value)
    @amount = value
    @amount = nil if @amount.to_f <= 0 #0 is absurd, negatives too
  end

  def is_minimum
    return @is_minimum if defined?(@is_minimum) 
    !!min_amount
  end

  def is_minimum=(value)
    @is_minimum = (value == 'true')
  end

  def update_attribs_from_view
    self.min_amount = nil
    self.recommended_amount = nil
    if @is_minimum
      self.min_amount = @amount
    else
      self.recommended_amount = @amount
    end
  end

end
