require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  login_user

  describe "GET index" do
    it "assigns @orders" do
      order = FactoryGirl.create :order, user: @user
      get :index
      expect(assigns(:orders)).to eq [order]
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
end
