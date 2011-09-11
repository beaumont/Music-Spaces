class AddScheduledAtColumnToBdrb < ActiveRecord::Migration
  def self.up
    add_column :bdrb_job_queues, :scheduled_at, :datetime
  end

  def self.down
    #not needed
  end
end
