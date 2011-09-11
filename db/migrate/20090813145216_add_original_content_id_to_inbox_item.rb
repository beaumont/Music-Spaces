class AddOriginalContentIdToInboxItem < ActiveRecord::Migration
  def self.up
    add_column :inbox_items, :original_content_id, :integer

    items = InboxItem.find(:all, :include => :content)
    count = items.count
    idx = 0
    items.each do |ii|
      idx += 1
      puts "processing #{idx} of #{count}" if idx % 100 == 0
      ii.update_attribute(:original_content_id, ii.content.original_content_id)
    end 
  end

  def self.down
  end
end
