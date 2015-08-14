require 'rails_helper'

RSpec.describe "books/show.html.haml", type: :view do
  let(:book) { FactoryGirl.create :book }
  let(:rating) { FactoryGirl.create(:rating) }

  before do
    assign(:book, book)
    assign(:new_rating, rating)
  end

  it "displays the book" do
    render
    expect(rendered).to match(book.title)
  end

  it "displays the ratings" do
    render
    expect(rendered).to match(book.title)
  end

  it "displays a link to the author" do
    render
    expect(rendered).to match(book.author.to_s)
  end
end
