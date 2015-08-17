require 'rails_helper'

RSpec.describe "authors/index.html.haml", type: :view do
  it "displays all the authors" do
  	authors = []
  	5.times { authors << FactoryGirl.create(:author) }
    assign(:authors, Author.all.page(1))
    render

    authors.each {|a| expect(rendered).to match a.first_name}
  end
end
