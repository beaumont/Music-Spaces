class ClearingExistingModerationEvents < ActiveRecord::Migration
  def self.up
    # Current structure is invald -- converted reason to an array -- and there shouldn't be any on prod yet, so just start over
    Moderation::Event.delete_all
  end

  def self.down
  end
end
