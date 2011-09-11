# the idea was that if original content deleted, we can still find user, and also we can tell if the user's already adopted this item from a specified inbox, not just globally
class ContentImportDetails < ActiveRecord::Base
  belongs_to :previous_content, :class_name => 'Content'
  belongs_to :previous_owner, :class_name => 'User'
  belongs_to :new_owner, :class_name => 'User'
  belongs_to :inbox
  belongs_to :original_content, :class_name => 'Content'
  belongs_to :content, :class_name => 'Content' 
end