class AddDbTranslations < ActiveRecord::Migration
  def self.up
    add_column :contents, :title_ru, :string
    add_column :contents, :description_ru, :text
    add_column :db_files, :content_ru, :text
    add_column :profile_questions, :answer_ru, :text
    add_column :profile_questions, :question_ru, :string
    add_column :account_settings, :donation_title_ru, :string
    add_column :account_settings, :donation_button_label_ru, :string
    add_column :account_settings, :donation_request_explanation_ru, :text
    add_column :currency_types, :message_to_donors_ru, :text
    add_column :currency_types, :donation_button_label_ru, :string
    add_column :announcements, :message_to_donors_ru, :text
  end

  def self.down
    remove_column :announcements, :message_to_donors_ru
    remove_column :currency_types, :donation_button_label_ru
    remove_column :currency_types, :message_to_donors_ru
    remove_column :account_settings, :donation_request_explanation_ru
    remove_column :account_settings, :donation_button_label_ru
    remove_column :account_settings, :donation_title_ru
    remove_column :profile_questions, :question_ru
    remove_column :profile_questions, :answer_ru
    remove_column :db_files, :content_ru
    remove_column :contents, :description_ru
    remove_column :contents, :title_ru
  end
end
