class CreateDrbQueues < ActiveRecord::Migration
  def self.up
    create_table "bdrb_job_queues", :force => true do |t|
      t.binary   "args"
      t.string   "worker_name"
      t.string   "worker_method"
      t.string   "job_key"
      t.integer  "taken",          :limit => 11
      t.integer  "finished",       :limit => 11
      t.integer  "timeout",        :limit => 11
      t.integer  "priority",       :limit => 11
      t.datetime "submitted_at"
      t.datetime "started_at"
      t.datetime "finished_at"
      t.datetime "archived_at"
      t.string   "tag"
      t.string   "submitter_info"
      t.string   "runner_info"
      t.string   "worker_key"
    end
  end

  def self.down
    drop_table :bdrb_job_queues
  end
end
