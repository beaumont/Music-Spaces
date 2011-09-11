class CreateAccountSettings < ActiveRecord::Migration
  class AccountSetting < ActiveRecord::Base
    belongs_to :user
  end
  class User < ActiveRecord::Base
    has_one :account_setting
  end
  def self.up
    create_table :account_settings do |t|
      t.belongs_to :user
      t.string :paypal_email, :limit => 50
      t.string :donation_title
      t.string :donation_button_label, :default => "Donate", :limit => 70
      t.text :donation_welcome_text
      t.decimal :donation_amount, :precision => 10, :scale => 2, :null => true
      t.boolean :show_donation_basket, :default => false
      t.string :default_language, :default => 1819
      t.timestamps
    end
    User.transaction do
      User.find(:all).each{ |u| AccountSetting.create!({:user_id => u.id}) }
    end
  end

  def self.down
    drop_table :account_settings
  end
end
