class CreateActivityLogEven < ActiveRecord::Migration
  def self.up
    create_table :activity_log_even, :force => true do |t|
      SiteActivityLoggerForControllers.table_columns(t)
    end
  end

  def self.down
    drop_table :activity_log_even
  end
end
