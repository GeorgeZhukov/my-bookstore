require 'rails_helper'

RSpec.describe CartController, type: :controller do
  login_user

  before do
    # Fill cart
    book = create :book
    @user.cart.add_book book
  end

  describe "GET show" do

    context "intro" do
      it "assigns @cart" do
        cart = @user.cart
        get :show, id: :intro
        expect(assigns(:cart)).to eq cart
      end

      it "renders the intro template" do
        get :show, id: :intro
        expect(response).to render_template("intro")
      end
    end

    context "address" do
      it "renders the address template" do
        get :show, id: :address
        expect(response).to render_template("address")
      end
    end

    context "delivery" do
      it "renders the delivery template" do
        get :show, id: :delivery
        expect(response).to render_template("delivery")
      end
    end

    context "payment" do
      it "renders the payment template" do
        get :show, id: :payment
        expect(response).to render_template("payment")
      end
    end

  end

  describe "PUT update" do
    context "address" do
      it "redirects to delivery page" do
        shipping_address = attributes_for(:address)
        put :update, id: :address,
            shipping_address: {
              address: shipping_address[:address],
              phone: shipping_address[:phone],
              city: shipping_address[:city],
              zip_code: shipping_address[:zip_code],
              country: shipping_address[:country],
            },
            billing_address: {
              address: shipping_address[:address],
              phone: shipping_address[:phone],
              city: shipping_address[:city],
              zip_code: shipping_address[:zip_code],
              country: shipping_address[:country],
            },
            use_billing_address: "yes"
        expect(response).to redirect_to cart_path(:delivery)
      end
    end

    context "delivery" do
      let(:delivery) { create :delivery_service }

      it "redirects to payment page" do
        put :update, id: :delivery, delivery: delivery
        expect(response).to redirect_to cart_path(:payment)
      end
    end

    context "payment" do
      let(:credit_card) { attributes_for :credit_card }
      it "redirects to confirm page" do
        put :update, id: :payment, credit_card: {
                number: credit_card[:number],
                CVV: credit_card[:CVV],
                expiration_year: credit_card[:expiration_year],
                expiration_month: credit_card[:expiration_month],
                first_name: credit_card[:first_name],
                last_name: credit_card[:last_name]
                   }
        expect(response).to redirect_to cart_path(:confirm)
      end
    end
  end
end
