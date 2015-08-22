require 'rails_helper'

RSpec.describe "wish_list_books/index.html.haml", type: :view do

  it "renders the wish list books partials" do
    create :book
    assign(:books, Book.all.page(1))
    render
    expect(view).to render_template(partial: "wish_list_books/_book", count: 1)
  end

  it "renders the wish list is empty when no books in the wish list" do
    assign(:books, Book.all)
    render
    expect(rendered).to match I18n.t("wish_list_books.index.no_books")
  end

end
