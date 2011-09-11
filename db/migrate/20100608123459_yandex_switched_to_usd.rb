class YandexSwitchedToUsd < ActiveRecord::Migration
  def self.up
    ym = MonetaryProcessor.yandex
    ym.update_attribute(:currency, 'usd') if ym
  end

  def self.down
  end
end
