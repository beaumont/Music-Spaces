class AddSidToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :sid, :string
    add_index :users, [:sid]
    User.update_all(["sid = ?", User::SID_STUB], ['type = ?', 'User'])
  end

  def self.down
  end
end
