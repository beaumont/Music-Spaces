class TranslateKroogiNames < ActiveRecord::Migration
  def self.up
    add_column :user_kroogs, :name_ru, :string
    add_column :user_kroogs, :name_fr, :string
  end

  def self.down
    remove_column :user_kroogs, :name_fr
    remove_column :user_kroogs, :name_ru
  end
end
