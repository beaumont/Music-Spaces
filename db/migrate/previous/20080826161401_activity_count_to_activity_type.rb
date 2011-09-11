class ActivityCountToActivityType < ActiveRecord::Migration
  def self.up
    # Because wtf is an activity_count?
    rename_column :activities,      :activity_count_id, :activity_type_id
    rename_column :activity_counts, :activity_count_id, :activity_type_id
  end

  def self.down
    rename_column :activities,      :activity_type_id, :activity_count_id
    rename_column :activity_counts, :activity_type_id, :activity_count_id
  end
end
