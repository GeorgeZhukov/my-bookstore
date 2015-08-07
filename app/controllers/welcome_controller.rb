class WelcomeController < ApplicationController
  layout "landing"

  def index
    @books = Book.best_sellers
  end
end
