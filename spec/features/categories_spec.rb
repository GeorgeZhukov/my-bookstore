require 'rails_helper'

RSpec.feature "Categories", type: :feature do
  let!(:category) { create :category }
  let!(:book) { create :book, category: category }

  scenario "A user can see categories on books page" do
    categories = []
    10.times { categories << create(:category) }
    visit books_path
    categories.each { |category| expect(page).to have_content category.title }
  end

  scenario "A user can see books in selected category" do

    visit books_path
    click_link category.title
    expect(page).to have_content book.title
  end
end
