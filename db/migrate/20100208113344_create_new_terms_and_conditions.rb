class CreateNewTermsAndConditions < ActiveRecord::Migration
  def self.up
    create_table :terms_and_conditions, :force => true do |t|
      t.boolean :require_terms_acceptance, :null => false
      t.integer :terms_db_store_id
      t.integer :terms_db_store_ru_id
      t.timestamps
      t.integer :created_by_id
      t.integer :updated_by_id
    end

    #let's know at least who modified db_store record the latest
    add_column 'db_store', 'updated_by_id', :integer
    add_column 'db_store', 'updated_at', :datetime
  end

  def self.down
  end
end
