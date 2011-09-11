class ChangeAnnouncementToUseCorrectFields < ActiveRecord::Migration
  def self.up
    Announcement.find(:all, :conditions => ["show_donate_button = 1"]).each do |ann|
      if board = ann.board # locally some announcements had boards that were deleted
        board.show_donation_button = true
        board.amount_usd = ann.suggested_donation
        board.amount_wmr = ann.suggested_donation_wmr
        board.amount_wme = ann.suggested_donation_wme
        board.donation_button_label = ann.donate_button_label
        board.save(false)
      end
    end
  end

  def self.down
  end
end
