require 'rails_helper'

RSpec.describe RatingHelper, type: :helper do
  describe "#isMyRating" do
    let(:user) { create :user }
    let(:another_user) { create :user }

    before do
      allow(helper).to receive(:current_user).and_return(user)
    end

    it "returns positive if current user is owner of the rating" do
      rating = create :rating, user: user
      expect(helper.isMyRating(rating, true, false)).to be_truthy
    end
    it "returns negative if current user is NOT owner of the rating" do
      rating = create :rating, user: another_user
      expect(helper.isMyRating(rating, true, false)).to be_falsey
    end
  end
end
