# == Schema Information
# Schema version: 20100813143132
#
# Table name: user_address_book_items
#
# id :integer
# name :string(32)
# email :string(48)
# user_id :integer
#

class UserAddressBookItem < ActiveRecord::Base
  belongs_to :user
end
