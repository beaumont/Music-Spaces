class CreateTermsAcceptance < ActiveRecord::Migration
  def self.up
    create_table :terms_acceptances, :force => true do |t|
      t.integer :termable_id
      t.string :termable_type
      t.integer :user_id
      t.integer :terms_and_conditions_id
      t.timestamps
    end
  end

  def self.down
  end
end
