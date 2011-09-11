class GenerateRetrospectiveTpsBuyActivities < ActiveRecord::Migration
  def self.up
    Tps::GoodieTicket.succeeded.each do |ticket|
      Tps::GoodieTicket.connection.execute %Q{
      insert into activities(user_id, activity_type_id, from_user_id, from_username, content_id, content_type, created_at, updated_at, status)
      values (#{ticket.buyer_id}, #{Activity.mapid(:tps_goodie_bought)}, #{ticket.artist.id}, '#{ticket.artist.login}',
              #{ticket.id}, '#{ticket.class.name}', '#{ticket.created_at.to_s(:db)}', '#{ticket.updated_at.to_s(:db)}', #{Status::READ})
      }
    end
  end

  def self.down
  end
end
