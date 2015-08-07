class BooksController < ApplicationController
  load_and_authorize_resource
  add_breadcrumb "Books", :books_path

  def index
    if params[:search]
      flash[:notice]=params[:search]
      @books = @books.search params[:search]
    end
    @books = @books.page params[:page]
  end

  def show
    add_breadcrumb @book.title, @book
    @ratings = @book.ratings.approved.latest
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
    @cart.save
    flash[:notice] = "Book was successfully added to cart."
    redirect_to cart_path(:intro)
  end


end
