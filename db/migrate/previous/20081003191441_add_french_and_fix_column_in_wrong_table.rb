class AddFrenchAndFixColumnInWrongTable < ActiveRecord::Migration
  def self.up
    remove_column :db_files, :content_ru
    add_column :contents, :title_fr, :string
    add_column :contents, :description_fr, :text
    add_column :db_store, :content_fr, :text
    add_column :db_store, :content_ru, :text
    add_column :profile_questions, :answer_fr, :text
    add_column :profile_questions, :question_fr, :string
    add_column :account_settings, :donation_title_fr, :string
    add_column :account_settings, :donation_button_label_fr, :string
    add_column :account_settings, :donation_request_explanation_fr, :text
    add_column :currency_types, :message_to_donors_fr, :text
    add_column :currency_types, :donation_button_label_fr, :string
    add_column :announcements, :message_to_donors_fr, :text
  end

  def self.down
    add_column :db_files, :content_fr, :text
    remove_column :announcements, :message_to_donors_fr
    remove_column :currency_types, :donation_button_label_fr
    remove_column :currency_types, :message_to_donors_fr
    remove_column :account_settings, :donation_request_explanation_fr
    remove_column :account_settings, :donation_button_label_fr
    remove_column :account_settings, :donation_title_fr
    remove_column :profile_questions, :question_fr
    remove_column :profile_questions, :answer_fr
    remove_column :db_store, :content_fr
    remove_column :db_store, :content_ru
    remove_column :contents, :description_fr
    remove_column :contents, :title_fr
  end
end
