class ExpireOldActivities < ActiveRecord::Migration
  def self.up
    puts "Cycling through activities to remove those with expired content -- may take a while"
    ids = Activity.find(:all, :include => :content).select{|x| x.content.nil? }.map(&:id)
    Activity.delete_all ['id in (?)', ids] unless ids.empty?
  end

  def self.down
  end
end
