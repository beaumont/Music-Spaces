class DeleteFriendcastActivities < ActiveRecord::Migration
  def self.up
    unless RAILS_ENV == 'production' #already there
      Activity.delete_all('friendcast')
    end
  end

  def self.down
  end
end
