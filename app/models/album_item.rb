# == Schema Information
# Schema version: 20081006211752
#
# Table name: album_items
#
#  id            :integer(11)     not null, primary key
#  album_id      :integer(11)
#  content_id    :integer(11)
#  position      :integer(11)     default(0), not null
#  created_by_id :integer(11)     default(0), not null
#  created_at    :datetime
#  updated_at    :datetime
#

class AlbumItem < ActiveRecord::Base
  
  belongs_to :album, :class_name => 'Content', :conditions => ['type in (?)', Content::ALBUM_TYPE_NAMES]
  belongs_to :content
  
  acts_as_list :scope => :album

  def self.clean_duplicates!
    dups = AlbumItem.find_by_sql('select album_id, content_id, COUNT(id) as dup_count from album_items group by album_id, content_id having dup_count > 1')
    # For each album_item with duplicate parts
    dups.each do |dup|
      # Cycle through all duplicates, deleting all but the first
      AlbumItem.find(:all, :conditions => {:album_id => dup.album_id, :content_id => dup.content_id}).each_with_index do |item, index|
        next if index.zero?
        item.destroy
      end
    end
    dups.size
  end
  
end
