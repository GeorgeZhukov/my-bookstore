require 'rails_helper'

RSpec.describe "books/show.html.haml", type: :view do
  let(:book) { create :book }
  let(:rating) { create(:rating) }

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

  it "displays 'no ratings' book.ratings is empty" do
    render
    expect(rendered).to match(I18n.t("books.show.no_ratings"))
  end
end
