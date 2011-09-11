class InStartToDefaultAlbum < ActiveRecord::Migration
  def self.up
    User.find(:all).each do |user| 
      album = Album.find_or_create_featured_for(user)
      user.contents.each do |content|
        if content.can_be_in_gallery? && content.is_in_startpage
          content.albums << album
          content.save
        end
      end
    end
  end

  def self.down
    # not much to do here
  end
end
