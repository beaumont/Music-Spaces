class CreateBetaInviteRequests < ActiveRecord::Migration
  def self.up
    create_table :beta_invite_requests do |t|
      t.string :email
      t.datetime :invited_on
      t.belongs_to :user
      t.timestamps
    end
  end

  def self.down
    drop_table :beta_invite_requests
  end
end
