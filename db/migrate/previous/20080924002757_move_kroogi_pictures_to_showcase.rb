class MoveKroogiPicturesToShowcase < ActiveRecord::Migration
  def self.up
    Image.update_all ['is_in_gallery=?', true], ['cat_id=?', Content::CATEGORIES[:userpic][:id]]
  end

  def self.down
  end
end
