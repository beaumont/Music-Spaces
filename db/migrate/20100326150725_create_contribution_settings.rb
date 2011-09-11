class CreateContributionSettings < ActiveRecord::Migration
  def self.up
    create_table :contribution_settings, :force => true do |t|
      t.integer :content_id, :null => false
      t.column "min_amount", :decimal, :precision => 10, :scale => 2
      t.column "recommended_amount", :decimal, :precision => 10, :scale => 2
    end

    FolderWithDownloadables.find(:all).each do |fwd|
      raise "failed for #{fwd.id}!" unless fwd.create_contribution_setting
    end

    MusicAlbum.find(:all).each do |ma|
      if ma.downloadable?
        raise "failed for #{ma.id}!" unless ma.create_contribution_setting
      end
    end
  end

  def self.down
  end
end
