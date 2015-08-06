require 'rails_helper'

RSpec.feature "Admins", type: :feature do
  before do
    user = FactoryGirl.create :admin
    login_as(user, :scope => :user)
  end

  scenario "An admin can navigate to admin panel by link on main layout" do
    visit root_path
    expect(page).to have_link "Admin Panel"
    click_link "Admin Panel"
    expect(page).to have_content "Site Administration"
  end

  context "ratings" do
    scenario "An admin can approve pending ratings" do
      book = FactoryGirl.create :book
      rating = FactoryGirl.create :rating, book: book
      visit rails_admin.index_path("Rating")
      within "#bulk_form" do
        click_link "approve"
      end
      expect(page).to have_content "event approve fired"
    end

    scenario "An admin can reject pending ratings" do
      book = FactoryGirl.create :book
      rating = FactoryGirl.create :rating, book: book
      visit rails_admin.index_path("Rating")
      within "#bulk_form" do
        click_link "reject"
      end
      expect(page).to have_content "event reject fired"
    end
  end

  context "authors" do
    scenario "An admin can create an author" do
      visit rails_admin.index_path("Author")
      click_link "Add new"

      author = FactoryGirl.create :author
      within "#new_author" do
        fill_in "First name", with: author.first_name
        fill_in "Last name", with: author.last_name
        fill_in "Biography", with: author.biography
        click_button "Save"
      end
      expect(page).to have_content "Author successfully created"
    end

    scenario "An admin can read authors" do
      authors = []
      4.times { authors << FactoryGirl.create(:author) }
      visit rails_admin.index_path("Author")
      authors.each {|author| expect(page).to have_content author.first_name}
    end

    scenario "An admin can edit authors" do
      author = FactoryGirl.create :author
      visit rails_admin.edit_path("Author", id: author.id)
      within "#edit_author" do
        fill_in "Last name", with: Faker::Name.last_name
        click_button "Save"
      end
      expect(page).to have_content "Author successfully updated"
    end
  end
end
