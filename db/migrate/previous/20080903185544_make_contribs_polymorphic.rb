class MakeContribsPolymorphic < ActiveRecord::Migration
  def self.up
    rename_column :monetary_contributions, :board_id, :content_id 
    add_column :currency_types, :show_donation_button, :boolean, :default => false
    add_column :currency_types, :donation_button_label, :string
    add_column :currency_types, :message_to_donors, :text
    Announcement.find(:all, :conditions => ["show_donate_button = 1"]).each do |ann|
      c = CurrencyType.new({:show_donation_button => true, :donation_button_label => ann.donate_button_label, :message_to_donors => ann.message_to_donors})
      c.accountable = ann.board
      c.save
    end
  end

  def self.down
    remove_column :currency_types, :message_to_donors
    remove_column :currency_types, :donation_button_label
    remove_column :currency_types, :show_donation_button
    rename_column :monetary_contributions, :content_id, :board_id
  end
end
