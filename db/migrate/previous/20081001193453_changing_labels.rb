class ChangingLabels < ActiveRecord::Migration
  def self.up
    rename_column :account_settings, :donation_welcome_text, :donation_request_explanation
  end

  def self.down
    rename_column :account_settings, :donation_request_explanation, :donation_welcome_text
  end
end
