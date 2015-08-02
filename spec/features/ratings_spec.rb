require 'rails_helper'

RSpec.feature "Ratings", type: :feature do
  scenario "A user can see book approved ratings" do
    # Init ratings
    ratings = []
    book = FactoryGirl.create :book
    5.times { ratings << FactoryGirl.create(:rating, state: "approved", book: book) }

    visit book_path(book)
    ratings.each {|rating| expect(page).to have_content rating.review }
  end

  scenario "A user can't see book not approved ratings" do
    # Init ratings
    ratings = []
    book = FactoryGirl.create :book
    5.times { ratings << FactoryGirl.create(:rating, book: book) }

    visit book_path(book)
    ratings.each {|rating| expect(page).not_to have_content rating.review }
  end

  scenario "A user can add a new rating" do
    book = FactoryGirl.create :book

    visit book_path(book)
    within "#new_rating" do
      fill_in "Number", with: 3
      fill_in "Review", with: "Some text"
    end
    click_button "Create Rating"
    expect(page).to have_content "Thank you. The rating sent to administrator for review."
  end
end
