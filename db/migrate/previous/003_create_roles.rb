class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table (:roles, :options => 'TYPE=MyISAM') do |t|
       t.column :name, :string, :limit => 30, :null => false
       t.column :status, :integer, :limit => 4, :default => 1, :null => false
    end
    add_index(:roles, :name, :unique => true)
    add_index(:roles, :status)
    
    create_table (:roles_users, :id => false, :options => 'TYPE=MyISAM') do |t|
       t.column :user_id, :integer, :null => false
       t.column :role_id, :integer, :null => false
    end
    add_index(:roles_users, [:user_id, :role_id], :unique => true)
    
    say "Baseline data ..."
    
    # Now that all the tables are created, put some baseline data into them:
    # create all roles necessary for the application
    role_anon = Role.create(:name => "ANONYMOUS", :status => 1)
    role_admin = Role.create(:name => "ADMIN", :status => 1)
    role_user = Role.create(:name => "USER", :status => 1)
    
    say "Created baseline roles"
    
    # Create users
    user_sql = []
    user_sql << "('anonymous', 'anon@krugi.com', 'anonymous user', 1)"
    user_sql << "('chief', 'chief@krugi.com', 'The big cahuna', 1)"
    user_sql << "('joe', 'joe.blow@sonific.com', 'Joe Blow', 1)"    

    user_sql.each do |sql|
      ActiveRecord::Base.connection.execute("insert into users (login, email, display_name, status) values #{sql}")
    end
    
    ActiveRecord::Base.connection.execute("insert into roles_users values (1, 1)")
    ActiveRecord::Base.connection.execute("insert into roles_users values (2, 2)")
    ActiveRecord::Base.connection.execute("insert into roles_users values (3, 3)")    
    
    User.find(:all).each {|u| u.update_attribute(:password, 'password') }
    User.update_all ['created_at = ?', Time.now]
    User.update_all ['updated_at = ?', Time.now]    
  end

  def self.down
    drop_table :roles
  end
end
