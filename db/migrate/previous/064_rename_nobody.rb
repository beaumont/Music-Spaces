class RenameNobody < ActiveRecord::Migration
  def self.up    
    ActiveRecord::Base.connection.execute "update relationshiptypes set name = 'Only me' where id = -1"
  end

  def self.down
    ActiveRecord::Base.connection.execute "update relationshiptypes set name = 'Nobody' where id = -1"
  end
  
end
