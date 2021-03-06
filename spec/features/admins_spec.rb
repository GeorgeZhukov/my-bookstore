require 'rails_helper'

RSpec.feature "Admins", type: :feature do
  background do
    user = create :admin
    login_as(user, scope: :user)
  end

  scenario "An admin can navigate to admin panel by link on main layout" do
    visit books_path
    expect(page).to have_link I18n.t("admin_panel")
    click_link I18n.t("admin_panel")
    expect(page).to have_content "Site Administration"
  end

  context "ratings" do
    given!(:book) { create :book }
    given!(:rating) { create :rating, book: book }

    scenario "An admin can approve pending ratings" do
      visit rails_admin.index_path("Rating")
      within "#bulk_form" do
        click_link "approve"
      end
      expect(page).to have_content "event approve fired"
    end

    scenario "An admin can reject pending ratings" do
      visit rails_admin.index_path("Rating")
      within "#bulk_form" do
        click_link "reject"
      end
      expect(page).to have_content "event reject fired"
    end
  end

  context "authors" do
    given(:author) { create :author }

    scenario "An admin can create an author" do
      visit rails_admin.index_path("Author")
      click_link "Add new"

      within "#new_author" do
        fill_in "First name", with: author.first_name
        fill_in "Last name", with: author.last_name
        fill_in "Biography", with: author.biography
        attach_file "Photo", 'spec/fixtures/images/ayn_rand.jpg'
        click_button "Save"
      end
      expect(page).to have_content "Author successfully created"
    end

    scenario "An admin can read authors" do
      authors = []
      4.times { authors << create(:author) }
      visit rails_admin.index_path("Author")
      authors.each {|author| expect(page).to have_content author.first_name}
    end

    scenario "An admin can edit authors" do
      visit rails_admin.edit_path("Author", id: author.id)
      within "#edit_author" do
        fill_in "Last name", with: Faker::Name.last_name
        click_button "Save"
      end
      expect(page).to have_content "Author successfully updated"
    end
  end
end
