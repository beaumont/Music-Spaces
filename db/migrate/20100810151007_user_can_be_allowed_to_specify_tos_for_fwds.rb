class UserCanBeAllowedToSpecifyTosForFwds < ActiveRecord::Migration
  def self.up
    add_column :rare_user_settings, :fwd_tos_allowed, :boolean
  end

  def self.down
  end
end
