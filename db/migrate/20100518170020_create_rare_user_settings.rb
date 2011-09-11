class CreateRareUserSettings < ActiveRecord::Migration
  def self.up
    create_table :rare_user_settings, :force => true do |t|
      t.integer :user_id, :null => false
      t.boolean :questions_enabled
    end
  end

  def self.down
  end
end
