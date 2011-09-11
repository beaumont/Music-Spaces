class AlterContents6 < ActiveRecord::Migration
  def self.up
    Track.find(:all).each do |item| 
      item.is_in_startpage = true
      item.is_in_gallery = true
      item.cat_id = Content::CATEGORIES[:track][:id]
      item.save!
    end

    Image.find(:all, :conditions => {:cat_id => 0}).each do |item| 
      item.is_in_startpage = true
      item.is_in_gallery = true
      item.cat_id = Content::CATEGORIES[:image][:id]
      item.save!
    end

    Textentry.find(:all, :conditions => {:cat_id => 0}).each do |item| 
      item.is_in_startpage = true
      item.is_in_gallery = true
      item.cat_id = Content::CATEGORIES[:writing][:id]
      item.save!
    end

    Board.find(:all, :conditions => {:foruser_id => nil}).each do |item| 
      item.cat_id = Content::CATEGORIES[:announcement][:id]
      item.save!
    end

    Board.find(:all, :conditions => {:cat_id => 0}).each do |item| 
      item.cat_id = Content::CATEGORIES[:topic][:id]
      item.save!
    end

  end

  def self.down
  end
end