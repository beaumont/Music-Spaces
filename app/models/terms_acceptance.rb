#  create_table "terms_acceptances", :force => true do |t|
#    t.column "termable_id",             :integer
#    t.column "termable_type",           :string
#    t.column "user_id",                 :integer
#    t.column "terms_and_conditions_id", :integer
#    t.column "created_at",              :datetime
#    t.column "updated_at",              :datetime
#  end
#
class TermsAcceptance < ActiveRecord::Base
  belongs_to :termable, :polymorphic => true  
  belongs_to :user  
  belongs_to :terms_and_conditions

  named_scope :for_user, lambda { |user|
    { :conditions => { :user_id => user.id } }
  }

  named_scope :for_terms, lambda { |terms|
    { :conditions => { :terms_and_conditions_id => terms.id } }
  }
end
