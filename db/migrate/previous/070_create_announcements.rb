class CreateAnnouncements < ActiveRecord::Migration
  class Announcement < ActiveRecord::Base
  end

  def self.up
    create_table :announcements do |t|
      t.belongs_to :board
      t.boolean :show_donate_button, :default => false
      t.string :donate_button_label, :default => "Donate", :limit => 70
      t.decimal :suggested_donation, :precision => 10, :scale => 2, :null => true
      t.timestamps
    end
    ActiveRecord::Base.transaction do
      ActiveRecord::Base.connection.select_all("select id from contents where `type` = 'Board'").each{|b| Announcement.create!({:board_id => b["id"]})}
    end
  end

  def self.down
    drop_table :announcements
  end
end
