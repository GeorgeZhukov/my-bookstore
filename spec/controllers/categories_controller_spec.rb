require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  login_user
  let(:category) { FactoryGirl.create :category }

  describe "GET index" do
    it "assigns @categories" do
      get :index
      expect(assigns(:categories)).to eq [category]
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET show" do
    it "assigns @category" do
      get :show, id: category.id
      expect(assigns(:category)).to eq category
    end

    it "renders the show template" do
      get :show, id: category.id
      expect(response).to render_template("show")
    end
  end
end
