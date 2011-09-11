class ConvertRatingsToVotes < ActiveRecord::Migration
  def self.up
    Vote.delete_all('about is null')
    
    idx = 0
    count = Rating.count
    up = 0
    down = 0
    Rating.paginated_each(:per_page => 100, :order => 'id') do |rate|
      idx += 1

      rater = User.find(rate.rater_id)
      next unless rate.rated
      Thread.current['user'] = rater
      if rate.rating >= 3
        vote = rater.vote_up(rate.rated)
        up += 1
      else
        vote = rater.vote_down(rate.rated)
        down += 1
      end
      raise "failed to convert rating #{rate.id} to vote: #{vote.errors.full_messages}" if vote.new?
      puts "Processed #{idx} ratings out of #{count}" if idx % 100 == 0
    end

    puts "#{count} ratings converted to #{up} up and #{down} down votes"

    finder_params = {:conditions => 'about is not null'}
    count = Vote.count(finder_params)
    updated = 0
    idx = 0
    Vote.paginated_each(finder_params.merge(:per_page => 100, :order => 'id')) do |vote|
      idx += 1
      inbox = Inbox.find_by_id(vote.about.split(':')[1])
      next unless inbox
      inbox_item = inbox.get_connector(vote.voteable)
      next unless inbox_item
      updated += 1
      Vote.update_all(['voteable_type = ?, voteable_id = ?, about = null', inbox_item.class.name, inbox_item.id], ['id = ?', vote.id])
      puts "Processed #{idx} inbox votes out of #{count}" if idx % 100 == 0
    end
    
    puts "Processed #{count} inbox votes totally, updated #{updated}"
  end

  def self.down
  end
end
