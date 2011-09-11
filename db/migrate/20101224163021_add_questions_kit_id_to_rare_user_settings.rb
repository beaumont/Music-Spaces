class AddQuestionsKitIdToRareUserSettings < ActiveRecord::Migration
  def self.up
    add_column :rare_user_settings, :questions_kit_id, :string
  end

  def self.down
    remove_column :rare_user_settings, :questions_kit_id
  end
end