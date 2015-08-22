require 'rails_helper'

RSpec.describe "authors/show.html.haml", type: :view do
  let(:author) {create(:author)}

  before do
    assign(:author, author)
  end

  it "displays the author" do
    render
    expect(rendered).to match(author.to_s)
  end

  it "displays the author book" do
    create :book, author: author
    render
    expect(rendered).to match(author.books.first.title)
  end
end
