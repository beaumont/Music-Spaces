class AlterPublicQaTextRuColumn < ActiveRecord::Migration
  def self.up
    change_column 'public_questions', :text_ru, :text
  end

  def self.down
  end
end
