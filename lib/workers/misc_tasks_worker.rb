require 'base_worker'

class MiscTasksWorker < BaseWorker
  # Background worker to perform miscellaneous async tasks

  set_worker_name :misc_tasks_worker

  def create(args = nil)
    logger.info "misc_tasks_worker started"
    # this method is called, when worker is loaded for the first time
  end
  
  def send_to_all_friends(args)
    capture_exception('send_to_all_friends', :mail => true, :args => args) do
      activity_id, opts = *args
      activity = Activity.find_by_id(activity_id)
      if activity
        Activity.transaction do
          Activity.send_to_all_friends(activity, opts)
        end
      end
      persistent_job.finish!
    end
  end

end

