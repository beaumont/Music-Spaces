class CreateMonetaryProcessors < ActiveRecord::Migration
  def self.up
    create_table :monetary_processors do |t|
      t.string  :name
      t.string  :short_name
      t.string  :donation_account_identifier
      t.boolean :allow_withdrawal, :default => false
      t.boolean :allow_donation,   :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :monetary_processors
  end
end
