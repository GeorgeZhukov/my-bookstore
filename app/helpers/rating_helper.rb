module RatingHelper
  def isMyRating(rating, positive, negative)
    if current_user and current_user.ratings.include?(rating)
      positive
    else
      negative
    end
  end
end