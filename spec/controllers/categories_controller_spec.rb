require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:category) { create :category }

  describe "GET index" do
    before { get :index }

    it "assigns @categories" do
      expect(assigns(:categories)).to match_array [category]
    end

    it "renders the index template" do
      expect(response).to render_template("index")
    end
  end

  describe "GET show" do
    before { get :show, id: category.id }

    it "assigns @category" do
      expect(assigns(:category)).to eq category
    end

    it "assigns @books" do
      expect(assigns(:books)).to eq category.books.page(1)
    end

    it "renders the show template" do
      expect(response).to render_template("show")
    end
  end
end
