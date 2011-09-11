class MoveDirBdrbTasksToNewWorker < ActiveRecord::Migration
  def self.up
    update "update bdrb_job_queues set worker_name = 'directories_feeds_worker' where worker_method in
           ('populate_friendfeeds_on_collection_inclusion', 'remove_friendfeed_entries_after_inclusion_breaks')"
  end

  def self.down
  end
end
