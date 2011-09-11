class DisallowSmsDonation < ActiveRecord::Migration
  def self.up
    execute "UPDATE monetary_processors SET allow_donation = 0 where short_name='movable_broker' "
  end

  def self.down
    execute "UPDATE monetary_processors SET allow_donation = 1 where short_name='movable_broker' "
  end
end
