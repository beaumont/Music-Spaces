class AddShowAtToSytemMessageShowTriggers < ActiveRecord::Migration
  def self.up
    add_column :system_messages_show_triggers, :show_at, :datetime
    SystemMessages::ShowTrigger.update_all("show_at = '#{Time.now.to_s(:db)}'")
    remove_column :system_messages_show_triggers, :delay
  end

  def self.down
    remove_column :system_messages_show_triggers, :show_at
    add_column :system_messages_show_triggers, :delay, :integer
  end
end
