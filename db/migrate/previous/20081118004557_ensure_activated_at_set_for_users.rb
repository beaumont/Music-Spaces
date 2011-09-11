class EnsureActivatedAtSetForUsers < ActiveRecord::Migration
  def self.up
    User.update_all ['activated_at=?', Time.now], 'activation_code is null and activated_at is null'
  end

  def self.down
  end
end
