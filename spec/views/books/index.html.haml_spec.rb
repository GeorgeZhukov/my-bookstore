require 'rails_helper'

RSpec.describe "books/index.html.haml", type: :view do
  before do
    @books = []
    5.times { @books << create(:book) }
    assign(:books, Book.all.page(1))
  end

  it "renders collection" do
    render
    @books.each { |b| expect(rendered).to match b.title }
  end

  it "renders the correct partial" do
    render
    expect(view).to render_template(partial: "books/_collection", count: 1)
    expect(view).to render_template(partial: "books/_book", count: 5)
  end

end
