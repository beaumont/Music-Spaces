class MakeGoodieParticipantsAddressLonger < ActiveRecord::Migration
  def self.up
    change_column(:tps_participants, :address, :text)
    change_column(:tps_participant_info_requests, :address, :text)
  end

  def self.down
  end
end
