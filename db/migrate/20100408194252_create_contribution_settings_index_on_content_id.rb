class CreateContributionSettingsIndexOnContentId < ActiveRecord::Migration
  def self.up
    #added manually on Prod
    add_index "contribution_settings", ["content_id"], :name => "index_contribution_settings_on_content_id" unless RAILS_ENV == 'production'
  end

  def self.down
  end
end
