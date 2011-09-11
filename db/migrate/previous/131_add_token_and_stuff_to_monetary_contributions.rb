class AddTokenAndStuffToMonetaryContributions < ActiveRecord::Migration
  def self.up
    add_column :monetary_contributions, :param_set, :text
    add_column :monetary_contributions, :verified, :boolean, :default => false
    add_column :monetary_contributions, :invite_id, :integer
    change_column :profile_questions, :show_on_kroogi_page, :boolean, :default => false
    
    ProfileQuestion.find(:all, :conditions => {:show_on_kroogi_page => nil}).each{ |pq| pq.update_attribute(:show_on_kroogi_page, 0)}
    MonetaryContribution.update_all("verified = 1")
  end

  def self.down
    remove_column :monetary_contributions, :invite_id
    remove_column :monetary_contributions, :verified
    remove_column :monetary_contributions, :param_set
  end
end
