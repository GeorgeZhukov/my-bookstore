require 'rails_helper'

RSpec.feature "Ratings", type: :feature do
  let(:book) {  FactoryGirl.create :book }

  scenario "A user can see book approved ratings" do
    # Init ratings
    ratings = []
    5.times { ratings << FactoryGirl.create(:rating, state: "approved", book: book) }

    visit book_path(book)
    ratings.each {|rating| expect(page).to have_content rating.review }
  end

  scenario "A user can't see book not approved ratings" do
    # Init ratings
    ratings = []
    5.times { ratings << FactoryGirl.create(:rating, book: book) }

    visit book_path(book)
    ratings.each {|rating| expect(page).not_to have_content rating.review }
  end

  scenario "A user can add a new rating" do
    user = FactoryGirl.create :admin
    login_as(user, scope: :user)

    visit book_path(book)
    within "#new_rating" do
      fill_in "Review", with: "Some text"
    end
    click_button I18n.t("books.new_rating.submit")
    expect(page).to have_content (I18n.t"ratings.sent_to_review")
  end
end
