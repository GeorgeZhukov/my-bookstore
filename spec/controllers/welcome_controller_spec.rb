require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe "GET index" do
    it "assigns @books" do
      order = FactoryGirl.create :order
      order.add_book FactoryGirl.create(:book)
      order.checkout
      order.confirm
      order.finish
      get :index
      expect(assigns(:books)).to eq Book.best_sellers
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
end
