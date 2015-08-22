require 'rails_helper'

RSpec.feature "WishLists", type: :feature do
  given(:book) { create :book }

  scenario "A guest will be redirected to login page if will try add book to wish list" do
    visit book_path(book)
    click_link I18n.t("books.details.add_to_wish_list")
    expect(page).to have_content "Log in"
  end

  context "authorized user" do
    background do
      @user = create :user
      login_as(@user, scope: :user)

      # add book to wish list
      visit book_path(book)
      click_link I18n.t("books.details.add_to_wish_list")
    end

    scenario "A user should see 'No books' when wish list is empty" do
      user = create :user
      login_as(user, scope: :user)
      visit wish_list_books_path
      expect(page).to have_content I18n.t("wish_list_books.index.no_books")
    end

    scenario "A user can add book to wish list" do
      book2 = create :book
      visit book_path(book2)
      click_link I18n.t("books.details.add_to_wish_list")
      expect(page).to have_content (I18n.t"wish_list_books.create.successfully_added")
    end

    scenario "A user can see books in wish list" do
      visit wish_list_books_path
      expect(page).to have_content book.title
    end

    scenario "A user can remove book from wish list" do
      page.driver.submit :delete, wish_list_book_path(book), {}
      expect(page).to have_content (I18n.t"wish_list_books.destroy.successfully_destroyed")
    end
  end


end
