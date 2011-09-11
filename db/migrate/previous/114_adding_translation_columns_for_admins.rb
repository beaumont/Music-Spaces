class AddingTranslationColumnsForAdmins < ActiveRecord::Migration
  def self.up
    Faq.transaction do
      add_column :admin_flashes,            :message_ru,  :string
      add_column :faqs,                     :question_ru, :string
      add_column :faqs,                     :answer_ru,   :string
      add_column :paid_kroogi_explanations, :explanation_ru,  :string
    end
  end

  def self.down
    Faq.transaction do
      remove_column :admin_flashes,            :message_ru
      remove_column :faqs,                     :question_ru
      remove_column :faqs,                     :answer_ru 
      remove_column :paid_kroogi_explanations, :explanation_ru
    end
  end
end
