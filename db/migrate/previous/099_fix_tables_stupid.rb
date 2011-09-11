class FixTablesStupid < ActiveRecord::Migration
  def self.up
    
    %w{activities activity_counts comments contents contents_relationshiptypes db_files favorites invites playlist_items playlists profile_questions profile_types profiles relationships relationshiptypes roles roles_users taggings tags user_kroogs users votes}.each do |tablename|
      ActiveRecord::Base.connection.execute "ALTER TABLE #{tablename} ORDER BY id" unless tablename == 'contents_relationshiptypes' || tablename == 'roles_users'
      puts "ALTER TABLE #{tablename} ENGINE = InnoDB"
      ActiveRecord::Base.connection.execute "ALTER TABLE #{tablename} ENGINE = InnoDB"
    end
  end

  def self.down
  end
end
