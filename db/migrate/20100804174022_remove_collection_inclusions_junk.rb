class RemoveCollectionInclusionsJunk < ActiveRecord::Migration
  def self.up
    puts "#{ProjectAsContent.remove_junk.size} PACs removed"
  end

  def self.down
  end
end
