require 'rails_helper'

RSpec.feature "WishLists", type: :feature do
  before do
    user = FactoryGirl.create :user
    login_as(user, :scope => :user)
  end
  let(:book) { FactoryGirl.create :book }

  scenario "A guest will be redirected to login page if will try add book to wish list" do
    logout(:user)
    visit book_path(book)
    click_link I18n.t("books.show.add_to_wish_list")
    expect(page).to have_content "Log in"
  end

  scenario "A user can add book to wish list" do
    visit book_path(book)
    click_link I18n.t("books.show.add_to_wish_list")
    expect(page).to have_content "The book successfully added to wish list."
  end

  scenario "A user can see books in wish list" do
    visit book_path(book)
    click_link I18n.t("books.show.add_to_wish_list")
    visit wish_list_books_path
    expect(page).to have_content book.title
  end

  scenario "A user can remove book from wish list"
end
