class MarkOutgoingMessagesRead < ActiveRecord::Migration
  def self.up
    finder_params = {:conditions => 'activity_type_id = 12 and user_id = from_user_id'}
    count = Activity.count(finder_params)
    idx = 0
    updated = 0
    Activity.paginated_each(finder_params.merge(:per_page => 100, :order => 'id')) do |activity|
      idx += 1

      if activity.status == Status::ACTIVE
        activity.mark_read
        updated += 1
      end

      puts "Processed #{idx} activities out of #{count}" if idx % 100 == 0
    end
    puts "Processed #{count} activities totally, #{updated} updated"
  end

  def self.down
  end
end
