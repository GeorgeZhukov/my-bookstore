require 'rails_helper'

RSpec.feature "Books", type: :feature do
  given(:book) { create :book }

  scenario "A user see best sellers on home page" do
    # Init best sellers
    items = []
    5.times { items << create(:order_item) }

    visit root_path
    items.each do |item|
      expect(page).to have_content item.book.title
    end
  end

  scenario "A user can see list of books" do
    books = []
    5.times { books << create(:book) }
    visit books_path
    books.each{ |book| expect(page).to have_content book.title }
  end

  scenario "A user can see book details" do
    visit book_path(book)
    expect(page).to have_content book.title
    expect(page).to have_content book.description
  end

  scenario "A user can add book to cart" do
    visit book_path(book)
    click_button I18n.t("books.details.add_to_cart")
    visit cart_path(:intro)
    expect(page).to have_content book.title
  end

  scenario "A user can search books by title" do
    visit books_path
    within "#search-form" do
      fill_in "Search", with: book.title
    end
    page.find(:css, '#search-button').click
    expect(page).to have_content book.title
  end

  scenario "A user can search books by author" do
    visit books_path
    within "#search-form" do
      fill_in "Search", with: book.author.to_s
    end
    page.find(:css, '#search-button').click
    expect(page).to have_content book.title
  end
end