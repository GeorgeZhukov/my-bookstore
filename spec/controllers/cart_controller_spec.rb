require 'rails_helper'

RSpec.describe CartController, type: :controller do
  login_user

  before do
    # Fill cart
    book = FactoryGirl.create :book
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
end
