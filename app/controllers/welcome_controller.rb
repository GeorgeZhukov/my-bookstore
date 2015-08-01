class WelcomeController < ApplicationController
  def index
    @book = Book.first_or_create
  end

  def test
    @book = Book.first_or_create
    @book.update_attributes(params.require(:book).permit(:cover))
  end
end
