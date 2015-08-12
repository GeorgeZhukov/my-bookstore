require 'rails_helper'

RSpec.describe "books/show.html.haml", type: :view do
  let(:book) { FactoryGirl.create :book }

  it "displays the book" do
    assign(:book, book)
    assign(:new_rating, FactoryGirl.create(:rating))
    render
    expect(rendered).to match(book.title)
  end

  it "displays the ratings" do
    assign(:book, book)
    assign(:new_rating, FactoryGirl.create(:rating))
    render
    expect(rendered).to match(book.title)
  end
end
