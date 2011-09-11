class ChangingUserStates < ActiveRecord::Migration
  def self.up
    User.update_all 'state="blocked"', 'state="banned"'
  end

  def self.down
    User.update_all 'state="banned"', 'state="blocked"'
  end
end
