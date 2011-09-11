class KarmaPoint < ActiveRecord::Base
  belongs_to :referrer, :class_name => 'User'
  belongs_to :referred, :class_name => 'User'
  belongs_to :content
  has_one :monetary_donation
  
  before_save :apply_point_value
  
  named_scope :this_month, {:conditions => ["karma_points.created_at > ?",Date.today.beginning_of_month]}
  
  # Create a new karma point based on the id of another
  # Pass in additional parameters to store
  def self.create_from_id(id, opts={})
    opts[:action] = opts[:action].to_s if opts[:action]
    kp = find_by_id(id)
    KarmaPoint.create(kp.attributes.merge(opts)) if kp
  end
  
  protected
  
  def apply_point_value
    self.send(:points=, 
    case action
      when 'download'
        1
    else
      0
    end
    )
  end
  
end