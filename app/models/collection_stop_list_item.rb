#  create_table 'collection_stop_list_items', :force => true do |t|
#    t.integer :parent_id, :null => false
#    t.integer :child_id, :null => false
#  end
#

class CollectionStopListItem < ActiveRecord::Base
  belongs_to :parent, :class_name => 'CollectionProject'
  belongs_to :child, :class_name => 'User'
end
