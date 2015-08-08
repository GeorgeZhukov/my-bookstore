require 'rails_helper'

RSpec.feature "Cart", type: :feature do
  before do
    # Add book
    book = FactoryGirl.create :book
    visit book_path(book)
    click_button I18n.t("books.show.add_to_cart")
  end

  scenario "A user should see 'Your cart is empty' when no items in cart" do
    OrderItem.all.destroy_all

    visit cart_path(:intro)
    expect(page).to have_content "Your cart is empty."
  end

  scenario "A user can clear the cart" do
    visit cart_path(:intro)
    click_link I18n.t("cart.intro.empty_cart")
    expect(page).to have_content "Your cart is cleared."
  end

  scenario "A user can change quantity of order item" do

    # Change quantity
    visit cart_path(:intro)
    fill_in "items__quantity", with: 5
    click_button I18n.t("cart.intro.update")
    expect(find_field('items__quantity').value).to eq "5"
  end

  scenario "A user can remove item from cart" do
    pending "can't click 'remove' button"
    # Get order item
    cart = User.first.cart
    order_item = cart.order_items.first
    visit cart_path(:intro)
    page.driver.submit :delete, remove_item_cart_path(cart, item_id: order_item.id), {}
    expect(page).not_to have_content order_item.book.title
  end

  scenario "A user should put his shipping and billing address" do
    address = FactoryGirl.create :address
    visit cart_path(:address)
    # click_button "Checkout"
    # Shipping address
    fill_in "shipping_address_address", with: address.address
    fill_in "shipping_address_zip_code", with: address.zip_code
    fill_in "shipping_address_city", with: address.city
    fill_in "shipping_address_phone", with: address.phone
    select "Ukraine", from: "shipping_address_country"

    # Billing address
    fill_in "billing_address_address", with: address.address
    fill_in "billing_address_zip_code", with: address.zip_code
    fill_in "billing_address_city", with: address.city
    fill_in "billing_address_phone", with: address.phone
    select "Ukraine", from: "billing_address_country"
    click_button I18n.t("cart.address.save_and_continue")
    expect(page).to have_content I18n.t("cart.delivery.delivery")
  end

  scenario "A user should choose delivery service" do
    # init delivery services
    delivery_services = []
    3.times { delivery_services << FactoryGirl.create(:delivery_service) }

    visit cart_path(:delivery)
    choose("delivery_#{delivery_services[1].id}")
    click_button I18n.t("cart.delivery.save_and_continue")
    expect(page).to have_content I18n.t("cart.payment.payment")
  end

  scenario "A user should put his credit card information" do
    credit_card = FactoryGirl.create :credit_card
    # Put addresses to show last page
    address = FactoryGirl.create :address
    visit cart_path(:address)
    # click_button "Checkout"
    # Shipping address
    fill_in "shipping_address_address", with: address.address
    fill_in "shipping_address_zip_code", with: address.zip_code
    fill_in "shipping_address_city", with: address.city
    fill_in "shipping_address_phone", with: address.phone
    select "Ukraine", from: "shipping_address_country"

    # Billing address
    fill_in "billing_address_address", with: address.address
    fill_in "billing_address_zip_code", with: address.zip_code
    fill_in "billing_address_city", with: address.city
    fill_in "billing_address_phone", with: address.phone
    select "Ukraine", from: "billing_address_country"
    click_button "Save And Continue"

    # put delivery service

    # init delivery services
    delivery_services = []
    3.times { delivery_services << FactoryGirl.create(:delivery_service) }

    visit cart_path(:delivery)
    choose("delivery_#{delivery_services[1].id}")
    click_button "Save And Continue"

    # Actually code to test current scenario
    visit cart_path(:payment)
    within "#new_credit_card" do
      fill_in "Number", with: credit_card.number
      fill_in "Cvv", with: credit_card.CVV
      select "7", from: "Expiration month"
      select Date.today.year, from: "Expiration year"
      fill_in "First name", with: credit_card.first_name
      fill_in "Last name", with: credit_card.last_name
      click_button "Save And Continue"
    end
    expect(page).to have_content "Place Order"
  end

  scenario "When user visit addresses step its init form with user addresses" do
    user = FactoryGirl.create :user
    login_as(user, :scope => :user)

    user.shipping_address = FactoryGirl.create :address
    user.billing_address = FactoryGirl.create :address
    user.save
    visit cart_path(:address)
    expect(page).to have_content user.shipping_address.address
    expect(page).to have_content user.billing_address.address
  end

  scenario "A user can checkout the order" do
    credit_card = FactoryGirl.create :credit_card
    # Put addresses to show last page
    address = FactoryGirl.create :address
    visit cart_path(:address)
    # click_button "Checkout"
    # Shipping address
    fill_in "shipping_address_address", with: address.address
    fill_in "shipping_address_zip_code", with: address.zip_code
    fill_in "shipping_address_city", with: address.city
    fill_in "shipping_address_phone", with: address.phone
    select "Ukraine", from: "shipping_address_country"

    # Billing address
    fill_in "billing_address_address", with: address.address
    fill_in "billing_address_zip_code", with: address.zip_code
    fill_in "billing_address_city", with: address.city
    fill_in "billing_address_phone", with: address.phone
    select "Ukraine", from: "billing_address_country"
    click_button "Save And Continue"

    # put delivery service

    # init delivery services
    delivery_services = []
    3.times { delivery_services << FactoryGirl.create(:delivery_service) }

    visit cart_path(:delivery)
    choose("delivery_#{delivery_services[1].id}")
    click_button "Save And Continue"

    # Actually code to test current scenario
    visit cart_path(:payment)
    within "#new_credit_card" do
      fill_in "Number", with: credit_card.number
      fill_in "Cvv", with: credit_card.CVV
      select "7", from: "Expiration month"
      select Date.today.year, from: "Expiration year"
      fill_in "First name", with: credit_card.first_name
      fill_in "Last name", with: credit_card.last_name
      click_button "Save And Continue"
    end
    click_link "Place Order"
    expect(page).to have_content "COmplete"
  end
end
