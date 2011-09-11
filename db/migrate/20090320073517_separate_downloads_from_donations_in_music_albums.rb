class SeparateDownloadsFromDonationsInMusicAlbums < ActiveRecord::Migration

  def self.create_download_activities(finder_params)
    count = MonetaryContribution.count(finder_params)

    puts "Cycling through all the MusicAlbum donations (%d) - this may take a bit" % count

    idx = 0
    MonetaryContribution.paginated_each(finder_params.merge(:per_page => 100,
      :order => 'monetary_contributions.id')) do |contrib|

      idx += 1

      if contrib.content.user
        username = contrib.content.user.login
      else
        puts "strange, content '%s' (%d) doesn't have user!" % [contrib.content.title, contrib.content.id]
      end

      Activity.create!(:user_id => (contrib.payer_id || -1),
        :activity_type_id => Activity::ACTIVITIES[:content_downloaded][:id],
        :status => Status::ACTIVE, :from_user_id => contrib.content.user_id,
        :from_username => username, :content_id => contrib.content.id,
        :content_type => 'Content', :created_at => contrib.created_at,
        :updated_at => contrib.updated_at,
        :monetary_contribution_id => contrib.id)

      puts "Processed #{idx} contributions of #{count}" if idx % 100 == 0
    end
    count
  end
  
  def self.up

    #this is here mostly to secure in case smth goes wrong in the middle of
    # migration. But generally we may need this link in further maintenance.
    add_column :activities, :monetary_contribution_id, :integer

    finder_params = {:include => :content,
      :conditions => "contents.type = 'MusicAlbum'"}

    count = create_download_activities(finder_params)

    ActiveRecord::Base.connection.update(
      "delete m.* from monetary_contributions m, contents c where m.content_id = c.id and c.type = 'MusicAlbum' and m.auth_amount = 0")

    puts "removed %d zero contributions (which are converted to downloads now)" % (count - MonetaryContribution.count(finder_params))
  end

  def self.down
    #no need
  end
end
