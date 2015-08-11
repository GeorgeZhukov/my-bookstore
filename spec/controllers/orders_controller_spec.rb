require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  login_user
  let(:order) { FactoryGirl.create :order, user: @user }

  describe "GET index" do
    xit "assigns @orders" do
      get :index
      expect(assigns(:orders)).to eq [order]
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET show" do
    it "assigns @order" do
      get :show, id: order.id
      expect(assigns(:order)).to eq order
    end

    it "renders the show template" do
      get :show, id: order.id
      expect(response).to render_template("show")
    end
  end
end
