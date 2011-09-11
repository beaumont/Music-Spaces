class AddContentIdIndexToActivities < ActiveRecord::Migration
  def self.up
    add_index "activities", ["content_id"], :name => "activities_content_id"
  end

  def self.down
  end
end
