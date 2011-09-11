class RenameAnonymousUser < ActiveRecord::Migration
  def self.up
    User.update_all(['login = ?', 'guest'], ['id = ?', User::ANONYMOUS_ID])
  end

  def self.down
  end
end
