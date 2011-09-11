class ImpactCounter < ActiveRecord::Base
  belongs_to :user
  belongs_to :to_user, :class_name => "User", :foreign_key => "to_user_id"
  belongs_to :content

  COUNTER_KINDS = {:download => 1, :donate => 2, :invite => 3}

  named_scope :with_user,   lambda {|who| { :conditions => ['user_id = ?', who.id]} }
  named_scope :for_content, lambda {|thing| { :conditions => ['content_id = ?', thing.id] } }
  named_scope :group_by_attr,    lambda {|thing| { :group => thing } }
  named_scope :order_by_attr,    lambda {|attr,sort| { :order => ["#{attr} #{sort}"] } }
  named_scope :download, { :conditions => ['counter_kind_id = ?', ImpactCounter::COUNTER_KINDS[:download]]}
  named_scope :donate,   { :conditions => ['counter_kind_id = ?', ImpactCounter::COUNTER_KINDS[:donate]]}
  named_scope :invite,   { :conditions => ['counter_kind_id = ?', ImpactCounter::COUNTER_KINDS[:invite]]}

end
