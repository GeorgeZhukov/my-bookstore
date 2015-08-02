require 'rails_helper'

RSpec.feature "Books", type: :feature do
  scenario "A user see best sellers on home page" do
    # Init best sellers
    items = []
    5.times { items << FactoryGirl.create(:order_item) }

    visit root_path
    items.each do |item|
      expect(page).to have_content item.book.title
    end
  end

  scenario "A user can see list of books" do
    books = []
    10.times { books << FactoryGirl.create(:book) }
    visit books_path
    books.each{ |book| expect(page).to have_content book.title }
  end

  scenario "A user can see book details" do
    book = FactoryGirl.create :book
    visit book_path(book)
    expect(page).to have_content book.title
    expect(page).to have_content book.description
  end

  scenario "A user can add book to cart" do
    book = FactoryGirl.create :book
    visit book_path(book)
    click_button "add to cart"
    visit cart_path(:intro)
    expect(page).to have_content book.title
  end

  scenario "A user can change quantity when add book to cart" do
    book = FactoryGirl.create :book
    visit book_path(book)
    fill_in "Quantity", with: 3
    click_button "add to cart"
    visit cart_path(:intro)
    expect(page).to have_content 3
  end
end