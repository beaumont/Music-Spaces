class AllowYandexForAll < ActiveRecord::Migration
  def self.up
    AccountSetting.update_all('allow_yandex = 1')
  end

  def self.down
  end
end
