class EnableRemovingBlockedEmails < ActiveRecord::Migration
  def self.up
    add_column :blocked_emails, :updated_by_id, :integer
    add_column :blocked_emails, :blocked_because_of, :string
  end

  def self.down
    remove_column :blocked_emails, :updated_by_id
    remove_column :blocked_emails, :blocked_because_of
  end
end
