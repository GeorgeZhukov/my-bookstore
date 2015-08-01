class BooksController < ApplicationController
  load_and_authorize_resource

  def index
    @books = @books.page params[:page]
    @categories = Category.all
  end

  def show
  end

  def add_to_cart
    book = Book.find(params[:id])
    authorize! :read, book
    quantity = params.fetch(:quantity, 1).to_i
    @cart = current_or_guest_user.cart
    @cart.add_book(book, quantity)
    @cart.save
    flash[:notice] = "Book was successfully added to cart."
    # redirect_to action: "show"
    redirect_to action: :index
  end
end
