class CreateMonetaryContributions < ActiveRecord::Migration
  def self.up
    create_table :monetary_contributions do |t|
      t.belongs_to :announcement, :account_setting
      t.integer :payer_id
      t.string  :address_state, :address_zip, :item_name, :receiver_id, :receiver_email
      t.decimal :auth_amount, :precision => 10, :scale => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :monetary_contributions
  end
end
