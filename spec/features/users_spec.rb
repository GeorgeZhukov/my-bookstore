require 'rails_helper'
require 'support/cart_feature_helper'

RSpec.feature "Users", type: :feature do
  include CartFeatureHelper

  context "authorized" do
    background do
      @user = create :user
      login_as(@user, scope: :user)
    end

    given(:address) { attributes_for :address }

    scenario "A user can edit billing address" do
      visit edit_user_registration_path
      within "#billing_address" do
        fill_in "Address", with: address[:address]
        fill_in "Zip code", with: address[:zip_code]
        fill_in "City", with: address[:city]
        fill_in "Phone", with: address[:phone]
        select "Benin", from: "Country"
        click_button "Save"
      end
      expect(page).to have_content I18n.t("devise.registrations.billing_saved")
    end

    scenario "A user can edit shipping address" do
      visit edit_user_registration_path
      within "#shipping_address" do
        fill_in "Address", with: address[:address]
        fill_in "Zip code", with: address[:zip_code]
        fill_in "City", with: address[:city]
        fill_in "Phone", with: address[:phone]
        select "Canada", from: "Country"
        click_button "Save"
      end
      expect(page).to have_content I18n.t("devise.registrations.shipping_saved")
    end

    context "saved addresses" do
      given(:address) { create :address }
      scenario "A user should see saved shipping address" do
        @user.shipping_address = address
        visit edit_user_registration_path
        expect(page).to have_content address.address
      end

      scenario "A user should see saved billing address" do
        @user.billing_address = address
        visit edit_user_registration_path
        expect(page).to have_content address.address
      end
    end
  end


  scenario "Guest orders reassign to user when he is logged in" do
    # Make order
    book = create :book
    visit book_path(book)
    click_button I18n.t("books.details.add_to_cart")
    visit cart_path(:address)
    fill_address
    fill_delivery
    fill_payment
    click_link I18n.t("cart.confirm.place_order")
    guest_order = Order.in_queue.first
    user = create :user
    login_as(user, scope: :user)
    visit orders_path
    expect(page).to have_content guest_order.number
  end

  scenario "Guest will be removed if user logged in" do
    pending "Can't remove guest now"
    book = create :book
    visit book_path(book)
    click_button I18n.t("books.details.add_to_cart")
    user = create :user
    login_as(user, scope: :user)
    visit cart_path(:intro)
    expect(User.count).to eq 1
  end
end
