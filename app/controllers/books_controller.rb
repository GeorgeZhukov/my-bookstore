class BooksController < ApplicationController
  load_and_authorize_resource
  add_breadcrumb (I18n.t"books.books"), :books_path

  def index
    @books = @books.search params[:search] if params[:search]
    @books = @books.page params[:page]
  end

  def show
    add_breadcrumb @book.title, @book
    @new_rating = current_or_guest_user.ratings.build
  end

  def add_to_cart
    book = Book.find(params[:id])
    authorize! :read, book
    if params[:add_to_cart]
      quantity = params[:add_to_cart].fetch(:quantity, 1).to_i
    else
      quantity = 1
    end
    @cart = current_or_guest_user.cart
    @cart.add_book(book, quantity)
    redirect_to cart_path(:intro), notice: (I18n.t"books.add_to_cart.books_was_successfully_added_to_cart")
  end


end
