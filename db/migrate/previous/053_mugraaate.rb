class Mugraaate < ActiveRecord::Migration
  def self.up
    anyone = Relationshiptype.find(-2)
    Content.find(:all, :conditions => "parent_id is null").each do |content|
      puts "Content:#{content.title}"
      if content.relationshiptypes.empty?
        content.relationshiptypes << anyone
        content.save
      end
    end
  end

  def self.down
  end
end
