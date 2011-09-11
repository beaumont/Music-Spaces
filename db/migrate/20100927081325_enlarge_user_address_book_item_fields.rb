class EnlargeUserAddressBookItemFields < ActiveRecord::Migration
  def self.up
    return if RAILS_ENV == 'production' #already there
    change_column(:user_address_book_items, :name, :string)
    change_column(:user_address_book_items, :email, :string)
  end

  def self.down
  end
end
