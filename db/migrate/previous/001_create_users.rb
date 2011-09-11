class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :options => 'TYPE=MyISAM', :force => true do |t|
      t.column :login,                     :string, :limit => 30, :null => false
      t.column :display_name,              :string  # default is varchar(255)
      t.column :email,                     :string, :limit => 255, :null => false
      t.column :crypted_password,          :string, :limit => 60, :null => false
      t.column :salt,                      :string, :limit => 60
      t.column :created_at,                :datetime, :null => false
      t.column :updated_at,                :datetime, :null => false
      t.column :created_by_id,             :integer, :default => 1, :null => false
      t.column :updated_by_id,             :integer, :default => 1, :null => false
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
      t.column :status,                    :integer, :limit => 4, :default => 1, :null => false
    end
    add_index(:users, :login, :unique => true)
    add_index(:users, :status)
  end

  def self.down
    drop_table "users"
  end
  
end
