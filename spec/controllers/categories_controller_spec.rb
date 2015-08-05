require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  login_user

  describe "GET index" do
    it "assigns @categories" do
      category = FactoryGirl.create :category
      get :index
      expect(assigns(:categories)).to eq [category]
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
end
