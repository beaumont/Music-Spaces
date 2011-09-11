class ConvertingTagsToLowercase < ActiveRecord::Migration
  def self.up
    Tag.find(:all).each {|t| t.update_attribute(:name, t.name.to_s.downcase)}
  end

  def self.down
  end
end
