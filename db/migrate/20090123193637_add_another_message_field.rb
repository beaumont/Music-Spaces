class AddAnotherMessageField < ActiveRecord::Migration
  def self.up
    add_column :announcements, :reason_for_kroogi_pass, :text
    add_column :announcements, :reason_for_kroogi_pass_ru, :text
    add_column :announcements, :reason_for_kroogi_pass_fr, :text
    
    Announcement.all(:conditions => {:generate_donor_coupons => true}).each do |ann|
      if curr = CurrencyType.find_by_accountable_id_and_accountable_type(ann.board_id, "Board")
        [nil, "_ru", "_fr"].each do |lang|
          ann["reason_for_kroogi_pass#{lang}"] = curr["message_to_donors#{lang}"]
        end
        ann.save(false)
      end
    end
  end

  def self.down
    remove_column :announcements, :reason_for_kroogi_pass_fr
    remove_column :announcements, :reason_for_kroogi_pass_ru
    remove_column :announcements, :reason_for_kroogi_pass
  end
end
