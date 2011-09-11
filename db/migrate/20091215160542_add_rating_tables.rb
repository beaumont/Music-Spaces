class AddRatingTables < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.create_ratings_table :with_stats_table => true, :stats_table_name => 'rating_stats'
    finder_params = {:conditions => 'about is null'} 
    count = Vote.count(finder_params)
    idx = 0
    Vote.paginated_each(finder_params.merge(:per_page => 100, :order => 'id')) do |vote|

      idx += 1

      if vote.is_a?(UpVote)
        vote.voteable.rate(5, vote.user)
      else
        vote.voteable.rate(1, vote.user)
      end
      puts "Processed #{idx} votes out of #{count}" if idx % 100 == 0
    end
    puts "Processed #{count} votes totally"
  end

  def self.down
    ActiveRecord::Base.drop_ratings_table :with_stats_table => true, :stats_table_name => 'rating_stats'
  end
end
