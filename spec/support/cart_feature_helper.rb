module CartFeatureHelper
  def fill_address
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
  end

  def fill_delivery
    delivery_services = []
    3.times { delivery_services << FactoryGirl.create(:delivery_service) }

    visit cart_path(:delivery)
    choose("delivery_#{delivery_services[1].id}")
    click_button "Save And Continue"
  end

  def fill_payment
    credit_card = FactoryGirl.create :credit_card
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
  end
end