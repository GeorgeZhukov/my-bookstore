require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  login_user

  let(:order) { create :order, user: @user }

  describe "GET index" do
    before { get :index }

    it "assigns @orders" do
      expect(assigns(:orders)).to match_array [order]
    end

    it "renders the index template" do
      expect(response).to render_template("index")
    end
  end

  describe "GET show" do
    before { get :show, id: order.id }

    it "assigns @order" do
      expect(assigns(:order)).to eq order
    end

    it "renders the show template" do
      expect(response).to render_template("show")
    end
  end
end
