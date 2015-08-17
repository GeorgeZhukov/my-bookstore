require 'rails_helper'

RSpec.describe "books/index.html.haml", type: :view do

  it "renders collection" do
  	books = []
  	5.times { books << FactoryGirl.create(:book) }
    assign(:books, Book.all.page(1))
    render
    books.each { |b| expect(rendered).to match b.title }
  end

end
