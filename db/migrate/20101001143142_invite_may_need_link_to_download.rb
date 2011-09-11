class InviteMayNeedLinkToDownload < ActiveRecord::Migration
  def self.up
    add_column :invites, :needs_link_to_download, :integer
  end

  def self.down
  end
end
