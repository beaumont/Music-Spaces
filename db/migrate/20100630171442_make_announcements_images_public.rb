class MakeAnnouncementsImagesPublic < ActiveRecord::Migration
  def self.up
    idx = 0
    count = CoverArt.count
    updated = 0
    CoverArt.paginated_each(:per_page => 100, :order => 'id') do |ca|
      puts "Processed #{idx} cover arts out of #{count}" if idx % 100 == 0
      idx += 1
      next unless ca.host_content.is_a?(Board)
      Thread.current['user'] = ca.created_by
      folder = ca.user.find_or_create_folder_for_pictures_from_notes
      ca.albums << folder unless ca.albums.include?(folder)
      ca.update_attributes(:relationshiptype_id => Relationshiptype.everyone, :is_in_gallery => true, :title => ca.host_content.title(40))
      updated += 1
    end
    puts "Processed #{idx} cover arts, updated #{updated}"
  end

  def self.down
  end
end
