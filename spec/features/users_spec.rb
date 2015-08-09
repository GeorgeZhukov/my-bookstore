require 'rails_helper'

RSpec.feature "Users", type: :feature do
  before do
    user = FactoryGirl.create :user
    login_as(user, scope: :user)
  end

  let(:address) { FactoryGirl.create :address }

  scenario "A user can edit billing address" do
    visit edit_user_registration_path
    within "#billing_address" do
      fill_in "Address", with: address.address
      fill_in "Zip code", with: address.zip_code
      fill_in "City", with: address.city
      fill_in "Phone", with: address.phone
      select "Benin", from: "Country"
      click_button "Save"
    end
    expect(page).to have_content 'The billing address is saved.'
  end

  scenario "A user can edit shipping address" do
    visit edit_user_registration_path
    within "#shipping_address" do
      fill_in "Address", with: address.address
      fill_in "Zip code", with: address.zip_code
      fill_in "City", with: address.city
      fill_in "Phone", with: address.phone
      select "Canada", from: "Country"
      click_button "Save"
    end
    expect(page).to have_content 'The shipping address is saved.'
  end
end
