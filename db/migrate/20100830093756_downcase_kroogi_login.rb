class DowncaseKroogiLogin < ActiveRecord::Migration
  def self.up
    User.kroogi.update_attribute(:login, 'kroogi') if User.kroogi
  end

  def self.down
  end
end
