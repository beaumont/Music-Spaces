class MigrateOlderActivitiesToContributionRelation < ActiveRecord::Migration
  def self.up
    Activity.update_all("content_type = 'MonetaryTransaction'", "content_type = 'MonetaryContribution'")
  end

  def self.down
  end
end
