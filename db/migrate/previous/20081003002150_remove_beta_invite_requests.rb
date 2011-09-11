class RemoveBetaInviteRequests < ActiveRecord::Migration
  def self.up
    drop_table :beta_invite_requests
  end

  def self.down
    create_table :beta_invite_requests do |t|
      t.string :email
      t.datetime :invited_on
      t.belongs_to :user
      t.timestamps
    end
  end
end
