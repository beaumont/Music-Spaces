class EnableEmailMessages < ActiveRecord::Migration
  def self.up

    ActiveRecord::Base.connection.execute "UPDATE users SET  email ='anon@kroogi.com' WHERE email = 'anon@crugi.com'"

    ActiveRecord::Base.connection.execute "UPDATE users SET email = 'chief@kroogi.com' WHERE email = 'chief@crugi.com'"

    User.find(:all, :conditions => "lower(login) = 'kroogi'").each do |kuser|
      return if kuser.nil?
      puts "UID:#{kuser.login}"
      User.find(:all, :conditions => "id not in (1, 2, 3) and id <> 40 and id <> #{kuser.id}").each do |cuser|
        puts "UID:#{cuser.login}"
        puts "already follower" if cuser.is_a_follower_of?(kuser)  # dont try we its a favorite already
        puts "project" if cuser.project?  # dont try we its a project
        if cuser.is_a_follower_of?(kuser) || cuser.project? 
          nil  # dont try we its a favorite already
        else
          puts "create rel for:#{cuser.login}"
          Relationship.create_user_relationship(cuser, kuser)
        end
      end

    end

    User.find(:all, :conditions => "lower(login) = 'sasha'").each do |user|
      puts "UID:#{user.id}"
      User.find(:all, :conditions => "id not in (1, 2, 3) and id <> 40 and id <> #{user.id}").each do |zuser| 
        if zuser.project?
          nil
        else
          ActiveRecord::Base.connection.execute "update preferences set email_notifications = 1 where user_id = '#{zuser.id}'"
        end
      end
    end
  end

  def self.down
    User.find(:all, :conditions => "lower(login) = 'sasha'").each do |user|
      ActiveRecord::Base.connection.execute "update preferences set email_notifications = 0 where user_id <> '#{user.id}'"
    end
  end
end
