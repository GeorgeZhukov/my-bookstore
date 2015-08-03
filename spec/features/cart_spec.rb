require 'rails_helper'

RSpec.feature "Cart", type: :feature do
  scenario "A user can change quantity of order item" do
    # Add book
    book = FactoryGirl.create :book
    visit book_path(book)
    click_button "add to cart"

    # Change quantity
    visit cart_path(:intro)
    fill_in "items__quantity", with: 5
    click_button "Update"
    expect(find_field('items__quantity').value).to eq "5"
  end
end
