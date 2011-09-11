class RemoveExtraCircleFromBasics < ActiveRecord::Migration
  def self.up
    conditions = {:conditions => ['type = ?', 'BasicUser']}
    count = User.count(conditions)
    page_size = 100
    user_idx = 0
    updated = 0
    User.paginated_each(conditions.merge(:order => 'id', :per_page => page_size)) do |user|
      puts "Processed #{user_idx} users out of #{count}." if user_idx % page_size == 0
      user_idx += 1
      updated += 1 if user.preference && user.preference.update_attributes!(:active_circle_ids => user.default_circles)
    end
    puts "Processed #{user_idx} basic users, updated #{updated}."
  end

  def self.down
  end
end
