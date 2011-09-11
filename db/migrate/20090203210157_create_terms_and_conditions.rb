class CreateTermsAndConditions < ActiveRecord::Migration
  def self.up
    create_table :terms_and_conditions do |t|
      t.string :title, :title_ru
      t.text :body, :body_ru
      t.timestamps
      t.integer :created_by_id
    end
  end

  def self.down
    drop_table :terms_and_conditions
  end
end
