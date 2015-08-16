class WelcomeController < ApplicationController

  def index
    @books = Book.best_sellers
    @coords = Address.all.map(&:coords).compact.map {|i| i << rand(0.03..0.2) }.flatten
  end
end
