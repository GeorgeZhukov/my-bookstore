require 'rails_helper'

RSpec.feature "WishLists", type: :feature do
  let(:book) { FactoryGirl.create :book }

  scenario "A guest will be redirected to login page if will try add book to wish list" do
    visit book_path(book)
    click_link I18n.t("books.show.add_to_wish_list")
    expect(page).to have_content "Log in"
  end

  context "authorized user" do
    before do
      user = FactoryGirl.create :user
      login_as(user, :scope => :user)

      # add book to wish list
      visit book_path(book)
      click_link I18n.t("books.show.add_to_wish_list")
    end
    scenario "A user can add book to wish list" do
      book2 = FactoryGirl.create :book
      visit book_path(book2)
      click_link I18n.t("books.show.add_to_wish_list")
      expect(page).to have_content "The book successfully added to wish list."
    end

    scenario "A user can see books in wish list" do
      visit wish_list_books_path
      expect(page).to have_content book.title
    end

    scenario "A user can remove book from wish list" do
      visit wish_list_books_path
      click_link "remove"
      expect(page).to have_content "The book has been successfully destroyed."
    end
  end


end
