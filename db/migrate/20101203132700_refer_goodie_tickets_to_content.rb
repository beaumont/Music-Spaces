class ReferGoodieTicketsToContent < ActiveRecord::Migration
  def self.up
    add_column :tps_goodie_tickets, :content_id, :integer rescue nil
    count = 0
    Tps::GoodieTicket.find(:all).each do |t|
      count += 1 if t.update_attributes!(:content_id => Tps::ContentDetails.find(t.content_details_id).content_id)
    end
    puts "updated #{count} tickets"
    remove_column :tps_goodie_tickets, :content_details_id
    change_column(:tps_goodie_tickets, :content_id, :integer, :null => false)
  end

  def self.down
  end
end
