class CreateUserAddressBookItems < ActiveRecord::Migration
  def self.up
    create_table :user_address_book_items do |t|
      t.string :name, :limit => 32
      t.string :email, :limit => 48
      t.integer :user_id
    end
  end

  def self.down
    drop_table :user_address_book_items
  end
end
