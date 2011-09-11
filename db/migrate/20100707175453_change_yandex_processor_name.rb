class ChangeYandexProcessorName < ActiveRecord::Migration
  def self.up
    MonetaryProcessor.yandex.update_attribute(:name, 'Yandex.Money') if MonetaryProcessor.yandex
  end

  def self.down
  end
end
