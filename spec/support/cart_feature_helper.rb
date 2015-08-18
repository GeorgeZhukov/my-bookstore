module CartFeatureHelper
  def fill_address(use_shipping_as_billing=true)
    address = FactoryGirl.create :address
    visit cart_path(:address)

    # Billing address
    fill_in "billing_address_address", with: address.address
    fill_in "billing_address_zip_code", with: address.zip_code
    fill_in "billing_address_city", with: address.city
    fill_in "billing_address_phone", with: address.phone
    select "Ukraine", from: "billing_address_country"

    unless use_shipping_as_billing
      # Shipping address
      fill_in "shipping_address_address", with: address.address
      fill_in "shipping_address_zip_code", with: address.zip_code
      fill_in "shipping_address_city", with: address.city
      fill_in "shipping_address_phone", with: address.phone
      select "Ukraine", from: "shipping_address_country"
    end

    click_button I18n.t("cart.address.save_and_continue")
  end

  def fill_delivery
    delivery_services = []
    3.times { delivery_services << FactoryGirl.create(:delivery_service) }

    visit cart_path(:delivery)
    choose("delivery_#{delivery_services[1].id}")
    click_button I18n.t("cart.delivery.save_and_continue")
  end

  def fill_payment
    credit_card = FactoryGirl.create :credit_card
    exp_date = Date.today + 1.year
    visit cart_path(:payment)
    within "#new_credit_card" do
      fill_in "Number", with: credit_card.number
      fill_in "Cvv", with: credit_card.CVV
      select exp_date.month, from: "Expiration month"
      select exp_date.year, from: "Expiration year"
      fill_in "First name", with: credit_card.first_name
      fill_in "Last name", with: credit_card.last_name
      click_button I18n.t("cart.payment.save_and_continue")
    end
  end
end