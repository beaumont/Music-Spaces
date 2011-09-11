class MovingOldOccupationsToTaglines < ActiveRecord::Migration
  def self.up
    Thread.current['user'] = User.find_by_login 'Kali' # For user_observer - can't be a project...
    raise "I know it's irrational, but the stupid user observer requires a valid CurrentUser set. Couldn't find Kali, fix manually." if Thread.current['user'].blank?
    
    puts "Setting tagline to occupation for all users..."
    User.active.find(:all, :include => :profile).each do |u|
      next unless u.profile && !u.profile.occupation.blank? && !u.profile.occupation.answer.blank?
      occ = u.profile.occupation.answer
      u.profile.update_attributes(:tagline => occ, :tagline_ru => occ)
    end
    Thread.current['user'] = nil # Probably not necessary    
  end

  def self.down
  end
end
