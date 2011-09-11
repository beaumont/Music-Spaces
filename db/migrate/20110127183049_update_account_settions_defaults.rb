class UpdateAccountSettionsDefaults < ActiveRecord::Migration
  def self.up
    change_column :account_settings, :donation_title, :string, :default => "Please support our project!"
    change_column :account_settings, :donation_title_ru, :string, :default => "Пожалуйста поддержите наш проект!"

    change_column :account_settings, :donation_button_label, :string, :default => "Contribute"
    change_column :account_settings, :donation_button_label_ru, :string, :default => "Поблагодарить"
  end

  def self.down
  end
end