class MakeMAsNotInviteToCircles < ActiveRecord::Migration
  def self.up
    count = 0
    MusicAlbum.find(:all).each do |ma|
      if ma.currency_type_object.circle_to_invite_to
        ma.currency_type_object.circle_to_invite_to = nil
        ma.currency_type_object.save!
        count += 1
      end
    end
    puts "removed invitation to circles setting from %s albums" % count
  end

  def self.down
  end
end
