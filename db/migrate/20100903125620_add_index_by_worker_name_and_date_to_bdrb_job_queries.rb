class AddIndexByWorkerNameAndDateToBdrbJobQueries < ActiveRecord::Migration
  def self.up
    unless RAILS_ENV == 'production' #already there
      execute 'alter table bdrb_job_queues add index index_bdrb_job_queues_on_worker_name_and_scheduled_at (worker_name, scheduled_at);'
    end
  end

  def self.down
  end
end
