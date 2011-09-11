class AddYandexMoney < ActiveRecord::Migration
  def self.up
    add_column :account_settings, :yandex_scid, :string
    add_column :account_settings, :yandex_shopid, :string
    add_column :account_settings, :allow_yandex, :boolean, :default => false
  end

  def self.down
    remove_column :account_settings, :allow_yandex
    remove_column :account_settings, :yandex_shopid
    remove_column :account_settings, :yandex_scid
  end
end
