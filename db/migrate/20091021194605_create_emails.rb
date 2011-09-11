class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.column :from, :string
      t.column :to, :string
      t.column :last_send_attempt, :integer, :default => 0
      t.column :mail, :text, :limit => 1.megabyte
      t.column :created_on, :datetime
      t.column :ready, :boolean, :default => 0, :null => false
    end
  end

  def self.down
    drop_table :emails
  end
end
