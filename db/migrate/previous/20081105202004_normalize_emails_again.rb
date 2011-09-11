class NormalizeEmailsAgain < ActiveRecord::Migration
  def self.up
    # A while ago we added +1, +2, etc to emails, because for a while there was only one account allowed per email. Reverting
    User.find(:all, :conditions => 'email like "%+%"').each do |user|
      user.update_attribute(:email, user.email.gsub(/\+\d+@/, '@'))
    end
  end

  def self.down
  end
end
