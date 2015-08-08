class RatingsController < ApplicationController


  before_action :authenticate_user!, only: [:create]

  load_and_authorize_resource :book
  load_and_authorize_resource :rating, through: :book

  add_breadcrumb "Ratings", :ratings_path

  def index
    @ratings = @ratings.approved.page params[:page]
  end

  def create
    rating = current_user.ratings.build(rating_params)
    rating.book = @book
    if rating.save
      redirect_to @book, notice: "Your rating has been successfully sent to review."
    else
      redirect_to @book
    end

  end

  private
  def rating_params
    params.require(:rating).permit(:review, :number)
  end
end
