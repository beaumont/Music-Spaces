class RollAnnouncementsUp < ActiveRecord::Migration
  def self.up
    Board.update_all "is_in_startpage = 1"
  end

  def self.down
    # sorry, no can do.
  end
end
