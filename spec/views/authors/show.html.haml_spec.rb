require 'rails_helper'

RSpec.describe "authors/show.html.haml", type: :view do
  let(:author) {FactoryGirl.create(:author)}
  it "displays the author" do
    assign(:author, author)
    render
    expect(rendered).to match(author.to_s)
  end

  it "displays the author book" do
    FactoryGirl.create :book, author: author
    assign(:author, author)
    render
    expect(rendered).to match(author.books.first.title)
  end
end
