require 'rails_helper'

RSpec.describe "authors/index.html.haml", type: :view do
  before do
    @authors = []
    5.times { @authors << FactoryGirl.create(:author) }
    assign(:authors, Author.all.page(1))
  end

  it "displays all the authors" do
    render
    @authors.each {|a| expect(rendered).to match a.first_name}
  end

  it "renders the correct partial" do
    render
    expect(view).to render_template(partial: "authors/_author", count: 5)
  end
end
