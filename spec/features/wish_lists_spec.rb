require 'rails_helper'

RSpec.feature "WishLists", type: :feature do
  before do
    user = FactoryGirl.create :user
    login_as(user, :scope => :user)
  end

  scenario "A user can add book to wish list" do
    book = FactoryGirl.create :book
    visit book_path(book)
    click_link "Add to wish list"
    expect(page).to have_content "The book successfully added to wish list."
  end

  scenario "A user can see books in wish list" do
    book = FactoryGirl.create :book
    visit book_path(book)
    click_link "Add to wish list"
    visit wish_list_books_path
    expect(page).to have_content book.title
  end

  scenario "A user can remove book from wish list"
end
