class WishListBooksController < ApplicationController
  before_action :authenticate_user!

  def index
    @books = current_user.get_wish_list.books
  end

  def create
    book = Book.find(params[:book_id])
    wish_list = current_user.get_wish_list
    wish_list.books << book
    if wish_list.save
      flash[:notice] = "The book successfully added to wish list."
    else
      flash[:notice] = "Some unknown error occurs."
    end
    redirect_to book_path(book)
  end
end
