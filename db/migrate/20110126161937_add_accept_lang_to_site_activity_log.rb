class AddAcceptLangToSiteActivityLog < ActiveRecord::Migration
  def self.up
    add_column :activity_log_even, :accept_language, :string, :limit => 100
    add_column :activity_log_odd, :accept_language, :string, :limit => 100
  end

  def self.down
    remove_column :activity_log_even, :accept_language
    remove_column :activity_log_odd, :accept_language
  end
end