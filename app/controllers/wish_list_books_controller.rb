class WishListBooksController < ApplicationController
  before_action :authenticate_user!

  add_breadcrumb (I18n.t"wish_list_books.wish_list_books"), :wish_list_books_path

  def index
    @books = current_user.get_wish_list.books.page params[:page]
  end

  def create
    book = Book.find params[:book_id]
    authorize! :read, book
    wish_list = current_user.get_wish_list

    if wish_list.books.include?(book)
      flash[:notice] = (I18n.t"wish_list_books.create.already_in_wish_list")
    else
      wish_list.books << book
      if wish_list.save
        flash[:notice] = (I18n.t"wish_list_books.create.successfully_added")
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
      redirect_to :back, notice: (I18n.t"wish_list_books.destroy.successfully_destroyed")
    else
      redirect_to :back, notice: "Unknown error occurs"
    end

  end
end
