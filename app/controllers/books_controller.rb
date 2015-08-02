class BooksController < ApplicationController
  load_and_authorize_resource

  def index
    if params[:search]
      @books = @books.search params[:search][:search]
    end
    @books = @books.page params[:page]
  end

  def show
    @ratings = @book.ratings.approved.latest
    @new_rating = current_or_guest_user.ratings.build
  end

  def add_to_cart
    book = Book.find(params[:id])
    authorize! :read, book
    quantity = params[:add_to_cart].fetch(:quantity, 1).to_i
    @cart = current_or_guest_user.cart
    @cart.add_book(book, quantity)
    @cart.save
    flash[:notice] = "Book was successfully added to cart."
    # redirect_to action: "show"
    redirect_to action: :index
  end


end
