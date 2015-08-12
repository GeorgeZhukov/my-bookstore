require 'rails_helper'

RSpec.describe "authors/index.html.haml", type: :view do
  xit "displays all the authors" do
    assign(:authors, [FactoryGirl.create(:author), FactoryGirl.create(:author)])
    render

    expect(rendered).to match /slicer/
    expect(rendered).to match /dicer/
  end
end
