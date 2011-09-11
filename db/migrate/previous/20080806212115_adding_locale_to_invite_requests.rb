class AddingLocaleToInviteRequests < ActiveRecord::Migration
  def self.up
    add_column :beta_invite_requests, :locale, :string
  end

  def self.down
    remove_column :beta_invite_requests, :locale
  end
end
