class UpdateAllExistingDownloadableContentItems < ActiveRecord::Migration
  def self.up
    Track.downloadable.each do |item|
      Content.without_monitoring do
        a = FileDownload.create_from_track(item)
        a.update_attribute(:created_by_id, item.user.id)
      end
    end
  end

  def self.down
  end
end
