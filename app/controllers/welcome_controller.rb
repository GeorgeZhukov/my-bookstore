class WelcomeController < ApplicationController

  def index
    @books = Book.best_sellers
  end
end
