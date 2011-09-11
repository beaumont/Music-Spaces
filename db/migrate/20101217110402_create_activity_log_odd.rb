class CreateActivityLogOdd < ActiveRecord::Migration
  def self.up
    create_table :activity_log_odd, :force => true do |t|
      SiteActivityLoggerForControllers.table_columns(t)
    end
  end

  def self.down
    drop_table :activity_log_odd
  end
end
