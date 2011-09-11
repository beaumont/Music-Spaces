class AddRussianDefaults < ActiveRecord::Migration
  def self.up
    AccountSetting.update_all ['donation_title_ru=?', "Поддержать"], 'donation_title_ru is null'
    AccountSetting.update_all ['donation_request_explanation_ru=?', "Пожалуйста, окажите поддержку&hellip;"], 'donation_request_explanation_ru is null'
  end

  def self.down
  end
end
