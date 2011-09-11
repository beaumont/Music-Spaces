class MakeRoomForGoodiesInsertions < ActiveRecord::Migration
  def self.up
    return if RAILS_ENV == 'production' #already there
    execute 'update tps_goodies set identifier = identifier*10 order by id desc'
  end

  def self.down
  end
end
