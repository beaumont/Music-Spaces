require 'base_worker'

class DirectoriesFeedsWorker < BaseWorker
  # Background worker to perform miscellaneous async tasks

  set_worker_name :directories_feeds_worker

  def create(args = nil)
    logger.info "directories_feeds_worker started"
    # this method is called, when worker is loaded for the first time
  end
  
  def populate_friendfeeds_on_collection_inclusion(pac_id)
    capture_exception('populate_friendfeeds_on_collection_inclusion', :mail => true, :args => [pac_id]) do
      pac = ProjectAsContent.find_by_id(pac_id)
      if pac
        ProjectAsContent.transaction do
          pac.do_populate_friendfeeds
        end
      end
      persistent_job.finish!
    end
  end

  def remove_friendfeed_entries_after_inclusion_breaks(args)
    capture_exception('remove_friendfeed_entries_on_breaking_collection_inclusion', :mail => true, :args => args) do
      body_project_id, old_parent_ids = *args
      ProjectAsContent.transaction do
        ProjectAsContent.remove_friendfeed_entries_after_inclusion_breaks(body_project_id, old_parent_ids)
      end
      persistent_job.finish!
    end
  end
  
end

