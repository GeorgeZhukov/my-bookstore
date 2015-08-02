class RatingsController < ApplicationController
  load_and_authorize_resource :book
  load_and_authorize_resource :rating, through: :book

  def index
    @ratings = @ratings.approved.latest.page params[:page]
  end

  def create
    rating = current_or_guest_user.ratings.build(rating_params)
    @book.ratings << rating
    # create_response(rating, "Your rating has been successfully sent to review.", book_path(@book))
    redirect_to @book
  end

  private
  def rating_params
    params.require(:rating).permit(:review, :number)
  end
end
