class UpdatingDefaultTeaser < ActiveRecord::Migration
  def self.up
    kroogs = UserKroog.find(:all)
    say "Updating #{kroogs.size} user_kroogs"

    kroogs.each do |kroog|
      if kroog.teaser && kroog.teaser.match(/Only followers who are in this circle or closer can post to this forum, read other posts and leave comments\./)
        # Changing default teaser
        kroog.update_attribute(:teaser, "Members receive updates on their home page when we post anything new. They are able to see entries that are intended to be seen by this circle and closer.")
      end
    end
  end

  def self.down
  end
end
