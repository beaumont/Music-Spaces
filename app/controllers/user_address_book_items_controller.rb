class UserAddressBookItemsController < ApplicationController

private
  def index
    @user = params[:id] ? User.find_by_id(params[:id]) || current_actor : current_actor
    @user = nil unless @user && @user.active?
    @user_address_book_items = @user.userAddressBookItems

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @user_address_book_items }
    end
  end

  # GET /user_address_book_items/new
  # GET /user_address_book_items/new.xml
  def new
    @user_address_book_item = UserAddressBookItem.new
  end

  # POST /user_address_book_items
  # POST /user_address_book_items.xml
  def create
    @user_address_book_item = UserAddressBookItem.new(params[:user_address_book_item])

    unless @user_address_book_item.save
      logger.debug "UserAddressBookItem there`s problem to save #{self.name} #{self.email} user_id==#{user_id}"
    end
  end

  # DELETE /user_address_book_items/1
  # DELETE /user_address_book_items/1.xml
  def destroy
    @user_address_book_item = UserAddressBookItem.find(params[:id])
    @user_address_book_item.destroy
  end
end
