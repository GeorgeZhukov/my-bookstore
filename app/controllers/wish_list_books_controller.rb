class WishListBooksController < ApplicationController
  before_action :authenticate_user!

  add_breadcrumb "Wish list books", :wish_list_books_path

  def index
    @books = current_user.get_wish_list.books
  end

  def create
    book = Book.find(params[:book_id])
    wish_list = current_user.get_wish_list

    if wish_list.books.include?(book)
      flash[:notice] = "The book already in wish list"
    else
      wish_list.books << book
      if wish_list.save
        flash[:notice] = "The book successfully added to wish list."
      else
        flash[:notice] = "Some unknown error occurs."
      end
    end

    redirect_to book_path(book)
  end

  def destroy
    wish_list = current_user.get_wish_list
    book = wish_list.books.find params[:id]
    if book.destroy
      redirect_to :back, notice: "The book has been successfully destroyed."
    else
      redirect_to :back, notice: "Unknown error occurs"
    end

  end
end
