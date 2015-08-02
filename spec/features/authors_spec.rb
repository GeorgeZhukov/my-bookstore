require 'rails_helper'

RSpec.feature "Authors", type: :feature do
  scenario "A user can see authors list" do
    authors = []
    10.times { authors << FactoryGirl.create(:author) }

    visit authors_path
    authors.each { |author| expect(page).to have_content author.first_name }
  end

  scenario "A user can see author details" do
    author = FactoryGirl.create :author
    visit author_path(author)
    expect(page).to have_content author.first_name
    expect(page).to have_content author.biography
  end
end
