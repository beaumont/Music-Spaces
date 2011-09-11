class EnableYandexProcessor < ActiveRecord::Migration
  def self.up
    MonetaryProcessor.yandex.update_attributes(:allow_donation => true) if MonetaryProcessor.yandex
  end

  def self.down
  end
end
