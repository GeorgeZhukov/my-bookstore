require 'rails_helper'

RSpec.feature "Authors", type: :feature do
  subject { FactoryGirl.create(:author) }

  scenario "A user can see authors list" do
    authors = []
    5.times { authors << FactoryGirl.create(:author) }

    visit authors_path
    authors.each { |author| expect(page).to have_content author.first_name }
  end

  scenario "A user can see author details" do

    visit author_path(subject)
    expect(page).to have_content subject.first_name
    expect(page).to have_content subject.biography
  end

  scenario "A user can see author books" do
    books = []
    4.times { books << FactoryGirl.create(:book) }
    subject.books = books
    subject.save
    visit author_path(subject)
    books.each {|book| expect(page).to have_content book.title }

  end
end
