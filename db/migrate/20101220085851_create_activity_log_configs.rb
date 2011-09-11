class CreateActivityLogConfigs < ActiveRecord::Migration
  def self.up
    create_table :activity_log_configs, :force => true do |t|
      t.boolean :monitoring, :default => false
      t.boolean :guests
      t.boolean :bots
      t.boolean :all_users, :default => true
      t.timestamps
    end

    SiteActivityLogConfig.create
  end

  def self.down
    drop_table :activity_log_configs
  end
end
