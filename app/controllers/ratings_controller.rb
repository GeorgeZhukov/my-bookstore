class RatingsController < ApplicationController
  # before_action :create, :authenticate_user!
  load_and_authorize_resource :book
  load_and_authorize_resource :rating, through: :book

  add_breadcrumb "Ratings", :ratings_path

  def index
    @ratings = @ratings.approved.latest.page params[:page]
  end

  def create
    rating = current_user.ratings.build(rating_params)
    @book.ratings << rating
    # create_response(rating, "Your rating has been successfully sent to review.", book_path(@book))
    flash[:notice] = "Thank you. The rating sent to administrator for review."
    redirect_to @book
  end

  private
  def rating_params
    params.require(:rating).permit(:review, :number)
  end
end
