class AddMoreRobustUserBlocking < ActiveRecord::Migration
  def self.up
    create_table (:blocked_emails, :options => 'TYPE=MyISAM') do |t|
       t.column :email, :string, :null => false
       t.timestamps
       t.integer :created_by_id
    end
    add_index(:blocked_emails, :email, :unique => true)
  end

  def self.down
    drop_table :blocked_emails
  end
end
