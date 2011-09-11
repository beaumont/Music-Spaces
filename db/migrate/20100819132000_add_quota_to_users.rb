class AddQuotaToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :upload_quota_mb, :integer
    User.update_all(['upload_quota_mb = ?', User.default_upload_quota_mb])
  end

  def self.down
  end
end
