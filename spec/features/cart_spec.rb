require 'rails_helper'
require 'support/cart_feature_helper'

RSpec.feature "Cart", type: :feature do
  include CartFeatureHelper

  context "empty cart" do
    scenario "A user should see 'Your cart is empty' when no items in cart" do
      visit cart_path(:intro)
      expect(page).to have_content (I18n.t"cart.intro.your_cart_is_empty")
    end
  end

  context "cart with item" do
    before do
      create :delivery_service
      # Add book
      book = create :book
      visit book_path(book)
      click_button I18n.t("books.details.add_to_cart")
    end

    scenario "A user can clear the cart" do
      visit cart_path(:intro)
      click_link I18n.t("cart.intro.empty_cart")
      expect(page).to have_content (I18n.t"cart.clear.cart_is_cleared")
    end

    scenario "A user can change quantity of order item" do

      # Change quantity
      visit cart_path(:intro)
      fill_in "items__quantity", with: 5
      click_button I18n.t("cart.intro.update")
      expect(find_field('items__quantity').value).to eq "5"
    end

    scenario "A user can remove item from cart" do
      # Get order item
      cart = User.first.cart
      order_item = cart.order_items.first
      visit cart_path(:intro)
      page.driver.submit :delete, remove_item_cart_path(:intro, item_id: order_item.id), {}
      expect(page).not_to have_content order_item.book.title
    end

    scenario "A user should put his shipping and billing address" do
      fill_address
      expect(page).to have_content I18n.t("cart.delivery.delivery")
    end

    scenario "Assigns addresses if needed" do
      user = create :user
      login_as(user, scope: :user)
      fill_address
      user.reload
      expect(user.shipping_address).not_to be_nil
      expect(user.billing_address).not_to be_nil
    end

    scenario "A user can use checkbox to use billing address as shipping address" do
      address = create :address
      visit cart_path(:address)

      # Billing address
      fill_in "billing_address_address", with: address.address
      fill_in "billing_address_zip_code", with: address.zip_code
      fill_in "billing_address_city", with: address.city
      fill_in "billing_address_phone", with: address.phone
      select "Ukraine", from: "billing_address_country"

      check 'use-billing-address'
      click_button I18n.t("cart.address.save_and_continue")
      expect(page).to have_content I18n.t("cart.delivery.delivery")
    end

    scenario "A user should choose delivery service" do
      fill_delivery
      expect(page).to have_content I18n.t("cart.payment.payment")
    end

    scenario "A user should put his credit card information" do
      fill_address
      fill_delivery
      fill_payment
      expect(page).to have_content (I18n.t"cart.confirm.place_order")
    end

    scenario "When user visit addresses step its init form with user addresses" do
      user = create :user
      login_as(user, scope: :user)

      user.shipping_address = create :address
      user.billing_address = create :address
      user.save
      visit cart_path(:address)
      # expect(page).to have_content user.shipping_address.address
      expect(page).to have_content user.billing_address.address
    end

    scenario "A user can checkout the order" do
      # Put addresses to show last page
      fill_address
      fill_delivery
      # Actually code to test current scenario
      fill_payment
      click_link I18n.t("cart.confirm.place_order")
      expect(page).to have_content I18n.t("order_helper.in_queue")
    end

    scenario "When the guest authorizes its basket preserved" do
      book = create :book
      visit book_path(book)
      click_button I18n.t("books.details.add_to_cart")

      user = create :user
      visit new_user_session_path
      within "#new_user" do
        fill_in "Email", with: user.email
        fill_in "Password", with: "password"
        click_button "Log in"
      end

      visit cart_path(:intro)
      expect(page).to have_content book.title
    end
  end

end
