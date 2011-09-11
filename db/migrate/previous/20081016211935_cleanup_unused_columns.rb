class CleanupUnusedColumns < ActiveRecord::Migration
  def self.up
    remove_column :announcements, :show_donate_button
    remove_column :announcements, :donate_button_label
    remove_column :announcements, :suggested_donation_wme
    remove_column :announcements, :suggested_donation_wmr
    remove_column :announcements, :suggested_donation_wmz
    remove_column :announcements, :suggested_donation
    remove_column :announcements, :message_to_donors
    remove_column :announcements, :message_to_donors_fr
    remove_column :announcements, :message_to_donors_ru
    
    drop_table :sessions    
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "This migration is not backwards compatible."
  end
end
