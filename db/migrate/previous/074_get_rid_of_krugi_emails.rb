class GetRidOfKrugiEmails < ActiveRecord::Migration
  def self.up

    ActiveRecord::Base.connection.execute "UPDATE users SET  email ='dummy@your-net-works.com' WHERE email like '%@krugi.com'"

  end

  def self.down
   nil
  end
end
