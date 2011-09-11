class TranslatableKroogiNames < ActiveRecord::Migration
  def self.up
    add_column :users, :display_name_ru, :string
    add_column :users, :display_name_fr, :string
  end

  def self.down
    remove_column :users, :display_name_fr
    remove_column :users, :display_name_ru
  end
end
