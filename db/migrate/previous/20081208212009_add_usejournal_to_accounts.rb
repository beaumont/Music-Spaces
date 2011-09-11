class AddUsejournalToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :usejournal, :string
  end

  def self.down
    remove_column :accounts, :usejournal
  end
end
