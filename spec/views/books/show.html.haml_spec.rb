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

  it "displays a link to the author" do
    render
    expect(rendered).to have_link (book.author.to_s)
  end

  it "displays 'no ratings' when book.ratings is empty" do
    render
    expect(rendered).to match(I18n.t("books.show.no_ratings"))
  end

  it "renders the correct partial" do
    render
    expect(view).to render_template(partial: "books/_details", count: 1)
  end

  it "renders the correct partial for ratings" do
    allow(view).to receive(:current_user).and_return(create :user)
    3.times { create :rating, book: book, state: :approved }
    assign(:book, book)
    render
    expect(view).to render_template(partial: "books/_rating", count: 3)
  end
end
